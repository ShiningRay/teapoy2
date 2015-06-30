# encoding: utf-8

# Public
# The topic model

class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ActsAsSoftDelete
  include Tenacity

  KEYS = %w(day week month year all)

  DateRanges = {
      '8hr' => 8.hour,
      'day' => 1.day,
      'week' => 1.week,
      'month' => 1.month,
      'year' => 1.year
  }

  auto_increment :_id
  field :tag_line, type: String
  field :comment_status, type: String
  field :anonymous, type: Boolean
  field :title, type: String
  field :top_post_id, type: Integer
  field :slug, type: String # cached slug
  field :score, type: Integer
  field :posts_count, type: Integer, default: 0

  default_scope -> { includes(:top_post) }

  class CannotReplyToClosedTopic < StandardError
  end

  include Navigation
  include TopPostAspect
  include AntiSpam
  include ChangeLogAspect
  include ActionView::Helpers::DateHelper
  include ScheduleAspect
  include AttachmentAspect
  harmonize :title
  check_spam :title
  STATUSES = %w(draft publish private pending spam deleted future)
  include Topic::StatusAspect
  has_many :posts
  belongs_to :group
  index({group_id: 1, status: 1, slug: 1}, {background: true})
  index({created_at: -1, group_id: 1, status: 1}, {background: true})
  t_belongs_to :user, class_name: 'User'

  # before_create {
  #   self[:posts_count] = 1 if top_post
  # }

  def comments
    posts.where(:floor.gt => 0).order_by(floor: :asc)
  end

  #attr_protected :score, :user_id, :status, :slug, :posts_count
  #validates_length_of    :content, minimum: 5, message: "对不起，您的内容太短了点……"
  #default_scope -> { where(status: %w(publish feature)) }
  attr_accessor :sync_to_sina

  def sync_to_sina=(val)
    @sync_to_sina = val
    @sync_to_sina = false if val == "0"
  end

  # def to_param
  #   slug.present? ? "#{id}-#{slug}" : id
  # end

  def change_group_status
    group.update_attributes!(status: "open")
  end

  def comments_count
    posts.count - 1
  end

  def rewards
    top_post.rewards
  end

  scope :by_period, ->(s, e) { where(:created_at.gte => s, :created_at.lt => e) }
  scope :by_date, ->(d) { where(:created_at.gte => d.beginning_of_day, :created_at.lte => d.end_of_day) }
  scope :anonymous, -> { where(anonymous: true) }
  scope :signed, -> { where(anonymous: false) }
  scope :latest, -> { order_by(created_at: 'desc') }
  scope :latest_created, -> { order_by(created_at: 'desc') }
  scope :latest_updated, -> { order_by(updated_at: 'desc') }
  scope :hottest, -> { order_by(score: 'desc') }
  scope :before, -> { where(:created_at.lt => Time.now) }

  def normalize_friendly_id(text)
    text.to_url.gsub(/[.\?~!\[\]\/()\*<>:#]/, '_')
  end

  attr_accessor :uncommentable, :content

  def uncommentable=(b)
    self.comment_status = ([0, '0', 'false', false].include?(b) ? 'open' : 'closed')
  end

  alias_method :original_user, :user

  def user
    anonymous ? User.guest : original_user
  end

  def user_id
    anonymous ? 0 : read_attribute(:user_id)
  end

  def anonymous?
    anonymous
  end

  def closed?
    comment_status == 'closed'
  end

  def has_comments? status='publish'
    comments.by_status(status).count > 0
  end

  def has_comments?
    posts.size > 1
  end

  # total_score
  def move_to(g, retain_repost = false)
    group = Group.wrap(g)
    gid = group.id
    return false if gid == group_id
    transaction do
      unless retain_repost
        top_post.move_to(group) if top_post.is_a?(Repost)
        self.group_id = gid
        posts.update_all group_id: gid
        self.publish! unless group.preferred_topics_need_approval?
      else
        op = Post.find top_post.id
        art = dup
        #transaction requires_new: true do
        art.group_id = gid
        art.slug = nil
        art.top_post = op
        art.posts_count = 1
        art.save!
        #end
        #op.group_id = gid
        #op.topic_id = art.id
        #op.save!
        p = Repost.new
        p.floor = 0
        p.topic_id = id
        p.group_id = group_id
        p.original_id = op.id
        p.anonymous = op.anonymous
        p.sharer_id = op.user_id
        p.user_id = op.user_id
        p.save!
        self.top_post(true)
        #p.save!
      end
      save!
    end
  end

  def move_out
    move_to 1
  end

  # sync top_post's score into the conversation
  def self.update_scores(cond=nil)
    post_ids = Rating.select('distinct(post_id)').where('created_at >= ?', 1.hour.ago).collect { |r| r.post_id }
    Post.where(:id.in => post_ids, :floor => 0, :topic_id.ne => nil).each do |post|
      post.topic.set(:score => post.score)
    end if post_ids.size > 0
    #connection.execute "UPDATE topics, posts SET topics.score = posts.score WHERE topics.id = posts.topic_id AND posts.id IN (#{post_ids.join(',')}) AND posts.floor = 0" if post_ids.size > 0
  end

  # Merge two topics into one
  # destination is topic1
  def self.merge(topic1, *topics)
    #Post._attr_readonly -= 'parent_id'
    topic1 = Topic.find(topic1) if topic1.is_a?(Fixnum) || topic1.is_a?(String)
    topics.each do |topic2|
      topic2 = Topic.find(topic2) if topic2.is_a?(Fixnum) || topic2.is_a?(String)
      floor_map = {}
      topic2.posts.each do |p|
        p.group_id = topic1.group_id
        p.topic_id = topic1.id
        if p.parent_id.blank?
          p.parent_id = 0
        else
          p.parent_id = floor_map[p.parent_id] || 0
        end

        orig_floor = p.floor
        p.floor = nil
        p.save!
        p.send :number_floor
        floor_map[orig_floor] = p.floor
      end
      #Rating.where(topic_id: topic2.id).update_all(topic_id: topic1.id)
      topic2.reload.destroy
    end
  end

  def to_post
    top_post
  end

  def topic_title(max_len=20)
    if title.blank?
      t = "\##{id} "
      unless top_post.blank? or top_post.content.blank?
        m = top_post.content.mb_chars
        t << (m.size > max_len ? "#{m[0, max_len]}..." : m) # rescue nil
      end
      t
    else
      title
    end
  end

  def self.find_by_slug(slug)
    where(slug: slug).first
  end

  def self.find_by_id(id)
    where(id: id).first
  end

  def self.remove_deleted
    unscoped.where(:status.in => %w(deleted spam)).each do |a|
      Post.collection.find(topic_id: a.id).remove_all
      Topic.collection.find(_id: a.id).remove_all
    end
  end

  protected
  before_save :remove_blank_title
  before_update :change_group, if: :group_id_changed?

  def remove_blank_title
    self.title = nil if title.blank?
  end

  def change_group
    posts.update_all group_id: group_id
  end

  after_destroy :remove_inbox_entry

  def remove_inbox_entry
    Inbox.where(topic_id: id).delete_all
  end
end