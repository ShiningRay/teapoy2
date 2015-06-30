# coding: utf-8
module Post::Tree
  extend ActiveSupport::Concern
  included do
    include Mongoid::Tree
    validates_with FloorParentValidator
    before_destroy :nullify_children
    # skip_callback :destroy, :before, :apply_orphan_strategy

    before_validation do
      # 如果文章存在并且没有指定 parent_id，则使用 top_post 作为 parent
      if topic and parent_id.blank? and floor != 0
        self.parent_id ||= topic.top_post_id
      end
      # 更新父级的 floor
      self.parent_floor = parent.floor if parent_floor.blank? and parent
    end
    validates :parent_id, presence: true, unless: ->(rec) { !topic || rec.floor == 0 }
  end

  def parent=(p)
    self.parent_floor = p.floor
    super(p)
  end

  class FloorParentValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:base] << 'floor cannot be same as parent_id' if record[:parent_floor] and record.floor and record.floor == record[:parent_floor]
    end
  end
end
