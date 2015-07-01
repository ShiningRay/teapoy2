# -*- coding: utf-8 -*-
class TopicSweeper < ActionController::Caching::Sweeper
  observe Topic

  def before_save(r)
    #on_delete(r)
  end

  def after_save(r)
    # expire_fragment [:mobile, r]

    # expire_fragment "footer/#{r.group_id}"
    #expire_page "/cache#{topic_path(r)}"
    #Rails.cache.delete("topic_next/#{group_id}/#{prev_in_group}")
    #Rails.cache.delete("topic_prev/#{group_id}/#{next_in_group}")
  end

  def before_destroy(r)
    #on_delete(r)
    Notification.delete_all :subject_type => 'Topic', :subject_id => r.id
  end

  def on_delete(r)
    a = r.group

    if r.next_in_group
      i = r.next_in_group
      Rails.cache.delete("topic_prev/#{a.id}/#{i}")
      expire_page "/cache#{topic_path(i)}"
    end

    if r.prev_in_group
      i = r.prev_in_group
      Rails.cache.delete("topic_next/#{a.id}/#{i}")
      expire_page "/cache#{topic_path(i)}"
    end

    expire_fragment "topic_content/#{r.id}"
    Rails.cache.delete "Topic/#{r.id}"
    expire_page "/cache#{topic_path(r.id)}"
  end
end

