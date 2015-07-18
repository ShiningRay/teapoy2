# coding: utf-8
#
module Topic::TopPostAspect
  extend ActiveSupport::Concern
  included do
    # has_one :top_post, -> { where(floor: 0) }, class_name: 'Post'#, autosave: true, inverse_of: :topic
    # belongs_to :top_post, class_name: 'Post', inverse_of: :topic
    attr_accessor :top_post_attributes#, :content
    # accepts_nested_attributes_for :top_post
    before_validation { top_post }
    after_save { top_post.save }
  end

  module ClassMethods

  end

  def top_post
    @top_post ||= new_record? ? build_top_post : find_top_post
  end

  def build_top_post(attrs=top_post_attributes)
    posts.top.new attrs do |top_post|
      # top_post.content = @content if @content.present?
      top_post.attachment_ids = @attachment_ids if @attachment_ids.present?
      top_post.group_id = group_id
      top_post.floor = 0
      top_post.parent_id = nil
      top_post.parent_floor = nil
      top_post.anonymous = anonymous
      top_post.user_id = self.user_id
      top_post.created_at = created_at
      top_post.topic_id = self.id
    end
  end

  def find_top_post
    posts.top.first
  end

  #module InstanceMethods
    def content
      top_post.content
    end

    def content=(c)
      top_post.content = c
    end
    def neg_score
      top_post.try(:neg)
    end

    # pos_score
    def pos_score
      top_post.try(:pos)
    end

    def total_score
      score || top_post.try(:score)
    end

  #end
end
