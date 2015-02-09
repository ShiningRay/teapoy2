# coding: utf-8
module Article::Navigation
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
    Article.public_articles.where(:group_id => group_id, :created_at.gt => created_at).latest.first
  end

  # find the previous entry in specific group
  # and some group may also include subgroup's entries
  def prev_in_group
    Article.public_articles.where(:group_id => group_id, :created_at.lt => created_at).latest.first
  end

  def self.included(base)
    base.send :include, Cache
  end
end
