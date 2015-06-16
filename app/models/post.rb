# encoding: utf-8
class Post
  include ::Post::Validators
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Paperclip
  include Tenacity

  belongs_to :group
  belongs_to :article, touch: true, counter_cache: true, inverse_of: :posts
  t_belongs_to :user#, class_name: 'User', foreign_key: :user_id

  field :content, type: String

  field :parent_floor, type: Integer
  field :neg, type: Integer, default: 0
  field :pos, type: Integer, default: 0
  field :score, type: Integer, default: 0
  field :anonymous, type: Boolean, default: false
  field :status, type: String
  #attr_accessible %i(id floor neg pos score status meta _type parent_id parent_ids)

  attr_accessor :type
  def total_score
    pos-neg
  end
  before_save do
    self.parent_floor = parent.floor if parent_floor.blank? and parent
  end
  include Tree
  include CallbacksAspect
  include FloorSequence
  include RepostAspect # add back later
  include AntiSpam
  include ParentDetection
  include MentionsDetection
  include RatableAspect
  include ContentFormat
  include RewardAspect
  include DescribedTargetAspect
  include ActionView::Helpers::DateHelper

  harmonize :content

  check_spam :content do |post|
    post.article.status = 'spam'
  end

  # def article
  #   #a = association(:article)

  #   Article.unscoped{ super }
  # end

  validates :parent_id, presence: true, unless: ->(rec) { rec.floor == 0 }

  scope :on_date, ->(date) { where(:created_at.gte => date.beginning_of_day, :created_at.lt => date.end_of_day)}
  scope :by_date, ->(date) { where(:created_at.gte => date.beginning_of_day, :created_at.lt => date.end_of_day)}
  scope :top, -> { where(floor: 0) }
  scope :latest, -> { order_by(:created_at.desc)}
  scope :today, -> { on_date(Date.today) }
  scope :anonymous, -> { where(anonymous: true) }
  scope :signed, -> { where(anonymous: false) }

  #attr_protected :floor, :neg, :pos, :score, :status, :meta
  #attr_readonly :user_id
  #validates_with DuplicateEliminator, fields: [:content]

  def top?
    floor == 0 || parent_id.blank?
  end

  def attachment?
    floor.to_i < 0
  end

  def comment?
    floor.to_i > 0
  end

  def repost?
    false
  end

  def move_to(group)
    raise CannotMovePost if reposted_to?(group)
  end

  alias_method :original_user, :user

  def user
    anonymous ? User.find(0) : original_user
  end

  def user_id
    anonymous ? 0 : read_attribute(:user_id)
  end
  #before_update :update_score

  def public?
    status == 'publish'
  end

  def to_post
    self
  end


  class << self
    def new_with_cast(*a, &b)
      if (h = a.first).is_a? Hash and (type = h.delete(:type) || h.delete('type')) and (klass = type.constantize) != self
        raise "wtF hax!!"  unless klass < self  # klass should be a descendant of us
        return klass.new(*a, &b)
      end
      new_without_cast(*a, &b)
    end

    alias_method_chain :new, :cast

    def wrap(id)
      case id
      when Post
        return id
      when String, BSON::ObjectId, Integer
        find_by_id id
      else
        id.to_post if id.respond_to?(:to_post)
      end
    end

    def find_by_id(id)
      where(id: id).first
    end
  end

  def recent_new?
    @recent_new ||= ((Time.now - created_at) < 3)
  end

  protected

  def as_json(opts={})
    opts ||= {}
    opts[:except] = [:device, :meta, :source, :ip, :ancestry, :ancestry_depth] + Array.wrap(opts.delete(:except))
    #opts[:includes] = :user
    res = super(opts)
    #@emoji ||= Emoji.create(:iphone)
    if res['content'].blank?
      res['content'] = ''
    else
      #res['content'].gsub! /(?::|：)([^\s]+?)(?::|：)/ do |m|
      #  @emoji.respond_to?($1) ? @emoji.send($1) : m
      #end
    end
    group = group || article.group
    res['parent_id'] ||= -1
    res['time_ago_in_words'] = time_ago_in_words(created_at)
    res[:group] = group.alias if group
    res[:type] = self.class.name
    res[:user] = user.as_json #if opts[:expand_user]
    res['status'] ||= ''
    res
  end
  public :as_json

  def self.fix_missing_article
    Article.observers.disable(Article::ChargeObserver)
    Post.where(floor: nil, parent_id: nil, article_id: nil).update(floor: 0)
    Post.where(article_id: nil).order_by(_id: :asc).each do |post|
      begin
      post.group_id ||= 1
      post.parent_ids ||= []
      post.save

      if post.parent_id.blank?
        post.floor ||= 0
        article = post.create_article(user_id: post.user_id,
          score: post.score,
          created_at: post.created_at,
          anonymous: post.anonymous,
          group_id: post.group_id,
          top_post_id: post.id,
          posts_count: 1)
        post.article_id = article.id
      else
        if post.parent
          post.article_id = post.parent.article_id
          post.group_id = post.parent.group_id
          post.parent.parent_ids ||= []
          post.save
        else
          post.parent_id = nil
          post.parent_ids = []
          post.floor = 0
          article = post.create_article(user_id: post.user_id,
            score: post.score,
            created_at: post.created_at,
            anonymous: post.anonymous,
            group_id: post.group_id,
            top_post_id: post.id)

          post.article_id = article.id
        end
      end
      post.save
      rescue
        Post.collection.find({_id: post.id}).remove
      end
    end
  end

  def self.remove_deleted
    Post.unscoped.where(:status.in => %w(deleted spam)).each do |post|
      Post.collection.find({:'$or' => [{:_id => post.id}, {:parent_id => post.id}, {:parent_ids => post.id}]}).remove_all
    end
  end

  def self.fix_missing_floor
    Post.where(:article_id.ne => nil, :floor => nil).each do |post|
      begin
        puts post.inspect
        article = post.article
        if post.id == article.top_post_id
          post.parent_id = nil
          post.parent_ids = []
          post.floor = 0
        else
          if post.parent_id.blank? or post.parent.blank?
            post.parent_floor = 0
            post.parent_id = article.top_post_id
            post.parent_ids = [article.top_post_id]
          end
          post.number_floor
        end
        post.save
        puts post.errors.inspect
      rescue
        Post.collection.find({_id: post.id}).remove
      end
    end
  end
end
