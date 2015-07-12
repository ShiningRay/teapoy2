# coding: utf-8
module Topic::Navigation
  module Cache
    def next_in_group
      Rails.cache.fetch([self, :next], :expires_in => 1.hour) { super }
    end
    def prev_in_group
      Rails.cache.fetch([self, :prev], :expires_in => 1.hour) { super }
    end
  end
  # find the next entry in specific group
  # and some group may also include subgroup's entries
  def next_in_group
    group.public_topics.after(created_at).oldest.first
  end

  # find the previous entry in specific group
  # and some group may also include subgroup's entries
  def prev_in_group
    group.public_topics.before(created_at).latest.first
  end

  def self.included(base)
    base.send :include, Cache
  end
end
