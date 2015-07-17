# encoding: utf-8
# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  content        :text(65535)      not null
#  user_id        :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#  ip             :integer          default(0), not null
#  group_id       :integer
#  topic_id       :integer          default(0), not null
#  floor          :integer
#  neg            :integer          default(0), not null
#  pos            :integer          default(0), not null
#  score          :integer          default(0), not null
#  anonymous      :boolean          default(FALSE), not null
#  status         :string(255)      default(""), not null
#  ancestry       :string(255)      default(""), not null
#  ancestry_depth :integer          default(0), not null
#  parent_floor   :integer
#  mentioned      :string(255)
#
# Indexes
#
#  article_id                                (topic_id,floor) UNIQUE
#  index_posts_on_ancestry                   (ancestry)
#  index_posts_on_reshare_and_parent_id      (parent_id)
#  index_posts_on_topic_id_and_parent_floor  (topic_id,parent_floor)
#  pk                                        (group_id,topic_id,floor) UNIQUE
#

class Post < ActiveRecord::Base
  include Validators

  belongs_to :group
  belongs_to :topic, touch: true, counter_cache: true
  belongs_to :user
  #attr_accessible %i(id floor neg pos score status meta _type parent_id parent_ids)

  attr_accessor :type
  def total_score
    pos-neg
  end

  include Tree
  include CallbacksAspect
  include FloorSequence
  # include RepostAspect # add back later
  include AntiSpam
  include ParentDetection
  include MentionsDetection
  include RatableAspect
  include ContentFormat
  include RewardAspect
  include DescribedTargetAspect
  include ActionView::Helpers::DateHelper
  include AttachmentsAspect

  harmonize :content

  check_spam :content do |post|
    post.topic.status = 'spam'
  end

  scope :on_date, ->(date) { where(:created_at.gte => date.beginning_of_day, :created_at.lt => date.end_of_day)}
  scope :by_date, ->(date) { where(:created_at.gte => date.beginning_of_day, :created_at.lt => date.end_of_day)}
  scope :top, -> { where(floor: 0) }
  scope :latest, -> { order(:created_at => :desc)}
  scope :today, -> { on_date(Date.today) }
  scope :anonymous, -> { where(anonymous: true) }
  scope :signed, -> { where(anonymous: false) }

  #attr_protected :floor, :neg, :pos, :score, :status, :meta
  #attr_readonly :user_id
  #validates_with DuplicateEliminator, fields: [:content]
  before_validation {|post| post.content.strip! if post.content.present?}

  def top?
    floor == 0 || parent_id.blank?
  end

  def comment?
    floor.to_i > 0
  end

  def repost?
    false
  end


  alias_method :original_user, :user

  def user
    anonymous ? User.guest : original_user
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
