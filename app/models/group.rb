# -*- coding: utf-8 -*-

class Group #< ActiveRecord::Base
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  disable_tags_index!
  include Tenacity

  #acts_as_nested_set
  include AntiSpam
  auto_increment :_id
  field :alias, type: String
  field :name, type: String
  field :description, type: String
  field :private, type: Boolean, default: false
  field :feature, type: Boolean, default: false
  field :hide, type: Boolean, default: false
  field :domain, type: String
  field :status, type: String
  field :theme, type: String
  embeds_one :options, class_name: 'GroupOptions', autobuild: true
  accepts_nested_attributes_for :options
  #acts_as_publisher
  # paginates_per 30
  # acts_as_taggable
  # attr_readonly :alias
  has_many :topics, dependent: :destroy
  #has_many :public_topics, class_name: 'Topic', conditions: {status: 'publish'}
  def public_topics
    topics.public_topics
  end
  #has_many :pending_topics, class_name: 'Topic', conditions: {status: 'pending'}
  def pending_topics
    topics.pending
  end

  t_belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :posts
  #has_many :memberships
  field :member_ids, type: Array, default: []
  #has_many :members, class_name: 'User', select: "memberships.group_id, memberships.role as membership_role, users.*", through: :memberships, source: :user
  #has_many :pending_members, class_name: 'User', through: :memberships, source: :user, conditions: "memberships.role = 'pending'"
  #validates_
  def members
    @members ||= User.where(id: member_ids).to_a
  end
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :alias, with: /\A[a-zA-Z_][a-zA-Z0-9_]{2,}\z/, allow_nil: false, allow_blank: false
  validates_uniqueness_of :alias
  index({name: 1}, {unique: true})
  index({alias: 1}, {unique: true})
  mount_uploader :icon, AvatarUploader, mount_on: :icon_file_name

  scope :public_groups, -> { where(private: false) }
  scope :private_groups, -> { where(private: true) }
  #scope :open_groups, -> { where(status: "open") }
  scope :hide_groups, -> { where(hide: true) }
  scope :not_pending, -> { where(:status.ne => 'pending') }
  scope :not_show_in_list, -> { where(hide: true).or(private: true) }
  scope :latest, -> { order_by(:created_at.desc) }

  harmonize :name, :description

  after_create :create_owner_membership

  def self.all_topics
    topics.unscoped
  end

  def self.find_by_alias(a, opt = {})
    where(:alias => a).first
  end

  def self.find_by_alias!(a, opt = {})
    where(:alias => a).first!
  end

  def create_owner_membership
    owner.join_group(self) if owner
  end

  before_create :lowercase_alias

  def merge_with(other_group)
    transaction do
      topics.each do |topic|
        topic.move_to other_group
      end
      members.each do |user|
        user.quit_group(self)
        user.join_group(other_group)
      end
    end
  end
  def lowercase_alias
    self.alias= self.alias.downcase
  end

  def recent_hottest_topic
    public_topics.hottest.first
  end

  def preferred_guest_can_reply?
    false
  end

  def preferred_guest_can_post?
    false
  end

  def to_param
    self.alias
  end
  # FIXME: use mongoid query
  def self.clear_self
    self.all.each do |g|
      unless Topic.exists?(["group_id = ? and created_at > ? and created_at < ?",g.id,1.day.ago,Time.now])
        g.update_attributes!(status:"close")
      end
    end
  end

  def self.update_scores
    today = Date.today
    Group.each do |g|
      g.inc(:score => g.topics.by_date(today).sum(:score))
    end
  end

  def subscribers
    Subscription.where(publication_type: 'Group', publication_id: id).includes(:subscriber).map{|s|s.subscriber}
  end

  def preferred_topics_need_approval?
    options.topics_need_approval
  end

  def preferred_membership_need_approval?
    options.membership_need_approval
  end

  def preferred_only_member_can_reply?
    options.only_member_can_reply
  end

  def self.wrap(obj)
    case obj
    when Group
      obj
    when Fixnum
      find_by_id obj
    when String
      find_by_alias obj
    end
  end

  def self.wrap!(obj)
    case obj
    when Group
      obj
    when Fixnum
      find obj
    when String
      find_by_alias! obj
    end
  end

  def self.find_by_domain(domain)
    where(domain: domain).first
  end

  def self.find_all_by_id(ids)
    where(:id.in => ids).all
  end

  def self.find_by_id(id)
    where(id: id).first
  end

  def self.find_by_alias!(a)
    find_by alias: a
  end

  def self.find_by_alias(a)
    where(alias: a).first
  end
end
