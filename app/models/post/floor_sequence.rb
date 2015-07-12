# coding: utf-8
module Post::FloorSequence
  extend ActiveSupport::Concern
  included do
    # include Mongoid::MagicCounterCache
    # field :floor, type: Integer, default: nil
    validates :floor, presence: true, uniqueness: {
      scope: :topic_id,
    }, if: 'topic'
    # index({topic_id: 1, floor: 1}, {unique: true, background: true})

    before_validation :number_floor, :if => 'topic && !floor'     # if floor is already calced, then return
    # counter_cache :topic, field: 'posts_count'
    after_create {
      notify_observers(:after_numbered)
    }
  end

  # get next floor number and save to floor field
  def number_floor
    self.floor = topic.posts.maximum(:floor) + 1
    logger.debug "use floor #{floor}"
  end

  def save(*args)
    # unless super
    #   # don't
    #   topic.inc(:posts_count => -1)
    #   false
    # else
    #   true
    # end
    super
  # rescue
  #   d = e.details
  #   if d['code'] == 11000 and d['err'] =~ /duplicate/
  #     logger.info("clash floor on #{self.floor} in #{self.topic_id} ")
  #     self.floor += 1
  #     # topic.inc(:posts_count => 1)
  #     retry
  #   else
  #     raise e
  #   end
  end

  module ClassMethods

    def find_by_floor(floor)
      where(floor: floor).first
    end

  end
end
