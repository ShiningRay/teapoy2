# encoding: utf-8
class Post
  include ::Post::Validators
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Paperclip
  include Tenacity

  belongs_to :group
  belongs_to :topic, touch: true, counter_cache: true, inverse_of: :posts
  t_belongs_to :user#, class_name: 'User', foreign_key: :user_id
  has_many :attachments
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
  include PictureAspect

  harmonize :content

  check_spam :content do |post|
    post.topic.status = 'spam'
  end

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
  before_validation {|post| post.content.strip!}
  def top?
    floor == 0 || parent_id.blank?
  end

  def comment?
    floor.to_i > 0
  end

  def repost?
    false
  end



  def attachment_ids_with_save_for_associate=(new_ids)
    if new_record?
      @attachment_ids = new_ids
    else
      self.attachment_ids_without_save_for_associate=new_ids
    end
  end

  alias_method_chain :attachment_ids=, :save_for_associate

  after_create :create_association_for_attachments
  def create_association_for_attachments
    if @attachment_ids.present?
      self.attachment_ids_without_save_for_associate = @attachment_ids
    end
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
    group = group || topic.group
    res['parent_id'] ||= -1
    res['time_ago_in_words'] = time_ago_in_words(created_at)
    res[:group] = group.alias if group
    res[:type] = self.class.name
    res[:user] = user.as_json #if opts[:expand_user]
    res['status'] ||= ''
    res
  end
  public :as_json
end
