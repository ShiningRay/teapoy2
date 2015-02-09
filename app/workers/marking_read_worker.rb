class MarkingReadWorker
  include Sidekiq::Worker
  def perform(user_id, article_id, floor=0)
    user = User.find user_id
    user.mark_article_as_read(article_id, floor)
  end
end