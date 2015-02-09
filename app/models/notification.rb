# coding: utf-8
#
# This is a model
class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  #belongs_to :user
  #belongs_to :subject, :polymorphic => true
  field :scope
  field :user_id, :type => Integer
  field :subject_type
  field :subject_id, :type => Integer
  index({:user_id=> 1,
         :scope=> 1,
         :subject_type=> 1,
         :subject_id=> 1}, {:unique => true})
  index({:user_id=> 1,
         :read=>    1}, {:background => true})

  #belongs_to :actor, :class_name => 'User'
  #serialize :content, JSONColumn.new(Hash)
  #store_accessor :content, :actor_ids, :source_ids
  field :actor_ids, :type => Array, :default => []
  field :source_ids, :type => Hash, :default => {}
  field :read, :type => Boolean, :default => false
  field :count, :type => Integer, :default => 0
  #has_and_belongs_to_many :actors, :uniq => true
  #has_and_belongs_to_many :sources, :uniq => true
  validates_each :actor_ids do |model, attr, val|
    actor_ids = val
    unless actor_ids.blank? or (actor_ids.is_a?(Array) and actor_ids.all?{|i|i.is_a?(Integer)})
      model.errors.add(attr, 'type mismatch')
    end
  end

  validates_each :source_ids do |model, attr, val|
    unless val.blank? or val.is_a?(Hash)
      model.errors.add(attr, 'type mismatch')
    end
  end
  # validates_each :source_ids do |model, attr, val|
  #   unless val.blank? or (val.is_a?(Hash) and val.all?{|i|
  #     i[1].all?{|j|
  #         j.is_a?(Integer)
  #       }
  #     })
  #     model.errors.add(attr, 'type mismatch')
  #   end
  # end
  scope :by_scope, -> s {where(:scope=>s.to_s)}
  scope :by_subject, -> s { where(:subject_type => s.class.name, :subject_id => s.id)}
  scope :latest, -> { order_by(:created_at => -1) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def sources
    @sources ||= grouped_sources.inject([]){|result, v| result + v[1]}
  end

  def subject
    @subject ||= subject_type && subject_id && subject_type.constantize.unscoped.where(id: subject_id).first
  end

  def subject=(subject)
    return unless subject
    self.subject_type = subject.class.name
    self.subject_id   = subject.id
  end

  def user
    @user ||= User.find(user_id)
  end

  def grouped_sources
    @grouped_sources ||=  begin
      s = source_ids.dup
      s.each_pair do |t, ids|
        t = t.constantize
        s[t] = t.find_all_by_id(id)
      end
      s
    end
  end

  def add_source(source)
    type = source.class.name
    source_ids[type] ||= []
    source_ids[type] << source.id unless source_ids[type].include?(source.id)
    @sources = nil
    @grouped_sources = nil
  end

  def remove_source(source)
    type = source.class.name
    source_ids[type].delete(source.id) unless source_ids[type].blank?
    @sources = nil
    @grouped_sources = nil
  end

  def add_sources(*sources)
    sources.flatten.compact.each do |s|
      add_source(s)
    end
  end

  def add_actor(actor)
    @actors = nil
    add_to_set(:actor_ids => User.wrap(actor).id)
  end

  def add_actors(*actors)
    @actors = nil
    actors.flatten.compact.each{|a| add_actor(a)}
  end

  def update_actors
    sources.each do |type, ids|
      t = type.safe_constantize
      next unless t.method_defined?(:user)
      o = t.find_all_by_id(ids)
      add_actors t.collect{|i|i.user}
    end
  end

  def remove_actor(actor)
    @actors = nil
    actor_ids.delete(User.wrap(actor).id)
  end

  def actors
    @actors ||= User.find_all_by_id(actor_ids)
  end

  def self.remove_read!
    where(:read => true).delete_all
  end

  def self.read!
    update_all(
      :read       => true,
      :actor_ids  => [],
      :source_ids => {},
      :count      => 0)
  end

  def read!
    self.read = true
    self.actor_ids = []
    self.source_ids = {}
    self.count = 0
    save!
  end
  class << self
    # send a notification
    # return: nil
    def send_to(user, scope, subject, actors = nil, sources=nil)
      user = User.wrap(user)
      note = Notification.find_or_initialize_by(
        :user_id => user.id,
        :scope => scope,
        :subject_type => subject.class.name,
        :subject_id => subject.id)
      note.add_actors(Array(actors)) unless actors.blank?
      note.add_sources(Array(sources)) unless sources.blank?
      note.read = false
      yield note if block_given?
      note.save!
    end

    def cleanup
      each do |n|
        n.destroy unless n.subject and !n.subject.destroyed?
      end
    end
  end
  after_save :send_mail, :unless => :read

  def send_mail
    if user.profile.want_receive_notification_email and user.logged_out?
      UserNotifier.delay.notify(self)
    end
  end

  before_validation :update_count
  def update_count
    self.count = source_ids.reduce(0){|sum, p| sum + p[1].size} unless source_ids.blank?
  end

  def as_json(opt={})
    super(:except => [:content, :user_id]).merge({:actors => actors.collect{|u| {"name"=>u.name,"login"=>u.login}}, :sources => source_ids})
  end
end
