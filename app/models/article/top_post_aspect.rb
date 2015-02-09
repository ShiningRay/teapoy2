# coding: utf-8
#
module Article::TopPostAspect
  extend ActiveSupport::Concern
  included do
    #has_one :top_post, -> { where(floor: 0)}, class_name: 'Post', autosave: true, inverse_of: :article
    belongs_to :top_post, class_name: 'Post', autosave: true, inverse_of: :article

    accepts_nested_attributes_for :top_post
    after_save :make_top_post
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

    def make_top_post(to_save = false)

      unless top_post
        p = posts.where(floor: 0).first
        if p
          self.top_post = p
          save!
        else
          build_top_post content: @content, user_id: user_id
        end
        #save!
      end

      top_post.group_id = group_id
      top_post.floor = 0
      top_post.anonymous ||= anonymous
      top_post.user_id ||= self[:user_id]
      top_post.created_at ||= created_at
      top_post.article_id = self.id
      top_post.save! if persisted? and top_post.new_record?
      top_post
    end
  #end
end
