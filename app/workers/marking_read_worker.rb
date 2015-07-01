class MarkingReadWorker
  include Sidekiq::Worker
  def perform(user_id, topic_id, floor=0)
    user = User.find user_id
    user.mark_topic_as_read(topic_id, floor)
  end
end