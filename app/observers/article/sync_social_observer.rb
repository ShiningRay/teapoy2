class Article::SyncSocialObserver < ActiveRecord::Observer
  observe :article
  def after_create(article)
    if article.sync_to_sina && !article.anonymous?
      SyncSocialWorker.perform_async(article.id)
    end
  end
end
