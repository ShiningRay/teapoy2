class Topic::SyncSocialObserver < ActiveRecord::Observer
  observe :topic
  def after_create(topic)
    if topic.sync_to_sina && !topic.anonymous?
      SyncSocialWorker.perform_async(topic.id)
    end
  end
end
