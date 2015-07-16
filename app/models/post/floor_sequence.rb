# coding: utf-8
# 每一个存入的 Post 在 Topic 中都有一个对应的 floor
# floor 唯一，线性增长
# 如果没有对应 topic，则不设置 floor，但无法存储
# floor 不可变

module Post::FloorSequence
  extend ActiveSupport::Concern
  included do
    # include Mongoid::MagicCounterCache
    # field :floor, type: Integer, default: nil
    validates :floor, presence: true, uniqueness: {
      scope: :topic_id,
    }
    # index({topic_id: 1, floor: 1}, {unique: true, background: true})

    # if floor is already calced, then return
    before_validation :number_floor, :if => 'new_record? and topic'
    # counter_cache :topic, field: 'posts_count'
    after_create {
      notify_observers(:after_numbered)
    }
  end

  # get next floor number and save to floor field
  def number_floor
    f = topic.posts.maximum(:floor)
    self.floor = f ? f + 1 : 0
    logger.debug "use floor #{floor}"
  end

  def create_or_update
    times = 0
    super
  rescue ActiveRecord::RecordNotUnique => e
    if times > 10
      raise e
    else
      logger.info("clash floor on #{self.floor} in #{self.topic_id} ")
      self.floor += 1
      times += 1
      # topic.inc(:posts_count => 1)
      retry
    end
  end

  module ClassMethods

    def find_by_floor(floor)
      where(floor: floor).first
    end

  end
end
