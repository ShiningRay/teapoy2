# coding: utf-8
module Post::FloorSequence
  extend ActiveSupport::Concern
  included do
    # include Mongoid::MagicCounterCache
    field :floor, type: Integer, default: nil
    # validates :floor, uniqueness: {
    #   scope: :article_id,
    # }
    index({article_id: 1, floor: 1}, {unique: true, background: true})

    before_validation :number_floor, :if => 'article && !floor'     # if floor is already calced, then return
    # counter_cache :article, field: 'posts_count'
    after_save {
      notify_observers(:after_numbered)
    }
  end

  # get next floor number and save to floor field
  def number_floor
    logger.debug "Find next floor number-#{article[:posts_count]}"
    if article[:posts_count].blank?
      article[:posts_count] = article.posts.where(:floor.ne => nil).count
      logger.debug "update article posts_count #{article[:posts_count]}"
      article.save
    end
    f = self[:floor] = article[:posts_count]
    logger.debug "use floor #{f}"
    self.floor = f
    # article.inc(:posts_count => 1)
    # notify_observers(:after_numbered)
  end

  def save(*args)
    # unless super
    #   # don't
    #   article.inc(:posts_count => -1)
    #   false
    # else
    #   true
    # end
    super
  rescue Moped::Errors::OperationFailure => e
    d = e.details
    if d['code'] == 11000 and d['err'] =~ /duplicate/
      logger.info("clash floor on #{self.floor} in #{self.article_id} ")
      self.floor += 1
      # article.inc(:posts_count => 1)
      retry
    else
      raise e
    end
  end

  module ClassMethods

    def find_by_floor(floor)
      where(floor: floor).first
    end

  end
end
