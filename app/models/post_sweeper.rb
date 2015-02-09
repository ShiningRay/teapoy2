# -*- coding: utf-8 -*-
class PostSweeper < ActionController::Caching::Sweeper
  observe Post

  def after_save comment
    expire_comment(comment)
  end

  def expire_comment(comment)
    #CommentWorker.async_sweep_cache(comment.id)
    #ScoreWorker.async_update(comment.article_id)
    expire_page "/cache#{article_path(comment.article_id)}"
    expire_page "/cache#{article_comments_path(comment.article_id)}"
  end
end
