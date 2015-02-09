# -*- coding: utf-8 -*-
class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article

  def before_save(r)
    #on_delete(r)
  end

  def after_save(r)
    # expire_fragment [:mobile, r]

    # expire_fragment "footer/#{r.group_id}"
    #expire_page "/cache#{article_path(r)}"
    #Rails.cache.delete("article_next/#{group_id}/#{prev_in_group}")
    #Rails.cache.delete("article_prev/#{group_id}/#{next_in_group}")
  end

  def before_destroy(r)
    #on_delete(r)
    Notification.delete_all :subject_type => 'Article', :subject_id => r.id
  end

  def on_delete(r)
    a = r.group

    if r.next_in_group
      i = r.next_in_group
      Rails.cache.delete("article_prev/#{a.id}/#{i}")
      expire_page "/cache#{article_path(i)}"
    end

    if r.prev_in_group
      i = r.prev_in_group
      Rails.cache.delete("article_next/#{a.id}/#{i}")
      expire_page "/cache#{article_path(i)}"
    end

    expire_fragment "article_content/#{r.id}"
    Rails.cache.delete "Article/#{r.id}"
    expire_page "/cache#{article_path(r.id)}"
  end
end

