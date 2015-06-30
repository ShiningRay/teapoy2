class Topic::SyncSocialObserver < ActiveRecord::Observer
  observe :topic
  def after_create(article)
    if article.sync_to_sina && !article.anonymous?
      SyncSocialWorker.perform_async(article.id)
    end
  end
end
