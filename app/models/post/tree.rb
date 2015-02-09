# coding: utf-8
module Post::Tree
  extend ActiveSupport::Concern
  included do
    include Mongoid::Tree
    validates_with FloorParentValidator
    before_destroy :nullify_children
    # skip_callback :destroy, :before, :apply_orphan_strategy
  end

  def parent=(p)
    self.parent_floor = p.floor
    super(p)
  end

  class FloorParentValidator < ActiveModel::Validator
    def validate(record)
      record.errors[:base] << "floor cannot be same as parent_id" if record[:parent_floor] and record.floor and record.floor == record[:parent_floor]
    end
  end
end
