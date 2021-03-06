# coding: utf-8
# 始终以 parent_floor 为准
#
module Post::Tree
  extend ActiveSupport::Concern
  included do
    # include Mongoid::Tree
    # has_ancestry
    validates_with FloorParentValidator
    before_destroy :nullify_children
    # skip_callback :destroy, :before, :apply_orphan_strategy

    before_validation do
      # 如果文章存在并且没有指定 parent_id，则使用 top_post 作为 parent
      if topic and parent_id.blank?
        if parent_floor
          self.parent_id ||= topic.posts.where(floor: parent_floor).pluck(:id).first
        else
          self.parent_id||= topic.top_post_id
        end
      end

    end
    validates :parent_floor, presence: true, unless: ->(rec) { !topic || rec.floor == 0 }
  end

  def nullify_children

  end

  def parent=(p)
    self.parent_floor = p.try :floor
    self.parent_id = p.try :id
    @parent = p
    # super(p)
  end

  def parent
    @parent ||= Post.where(id: parent_id).first
  end

  class FloorParentValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:base] << 'floor cannot be same as parent_id' if record[:parent_floor] and record.floor and record.floor == record[:parent_floor]
    end
  end
end
