# -*- coding: utf-8 -*-
class PostSweeper < ActionController::Caching::Sweeper
  observe Post

  def after_save comment
    expire_comment(comment)
  end

  def expire_comment(comment)
    #CommentWorker.async_sweep_cache(comment.id)
    #ScoreWorker.async_update(comment.topic_id)
    expire_page "/cache#{topic_path(comment.topic_id)}"
    expire_page "/cache#{topic_comments_path(comment.topic_id)}"
  end
end
