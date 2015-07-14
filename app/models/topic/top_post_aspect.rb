# coding: utf-8
#
module Topic::TopPostAspect
  extend ActiveSupport::Concern
  included do
    #has_one :top_post, -> { where(floor: 0)}, class_name: 'Post', autosave: true, inverse_of: :topic
    belongs_to :top_post, class_name: 'Post', inverse_of: :topic

    accepts_nested_attributes_for :top_post
    after_create :make_top_post
  end

  module ClassMethods

  end

  # def build_top_post(*args)
  #   super
  #   top_post.set
  # end

  #module InstanceMethods
    def content
      top_post.try(:content) || @content
    end

    def content=(c)
      @content = c
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

    def make_top_post

      unless top_post
        build_top_post content: @content, user_id: user_id
      end
      self.posts_count = 1
      top_post.group_id = group_id
      top_post.floor = 0
      top_post.parent_id = nil
      top_post.parent_floor = nil
      # top_post.parent_ids = []
      top_post.anonymous ||= anonymous
      top_post.user_id ||= self.user_id
      top_post.created_at ||= created_at
      top_post.topic_id = self.id
      top_post.attachment_ids = @attachment_ids if @attachment_ids.present?
      top_post.save!
      top_post
    end
  #end
end
