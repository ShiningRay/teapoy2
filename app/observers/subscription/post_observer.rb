class Subscription::PostObserver < Mongoid::Observer
  # observe :post
  # def after_create(article)
  #   Subscription.notify(Group, article)
  #   Subscription.notify(User, article)
  # end
end
