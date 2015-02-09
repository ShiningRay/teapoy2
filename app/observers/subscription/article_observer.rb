class Subscription::ArticleObserver < Mongoid::Observer
  observe :article
  def after_create(article)
    Subscription.notify(Group, article)
    Subscription.notify(User, article)
  end
end
