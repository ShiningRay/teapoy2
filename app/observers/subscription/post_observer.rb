class Subscription::PostObserver < Mongoid::Observer
  # observe :post
  # def after_create(topic)
  #   Subscription.notify(Group, topic)
  #   Subscription.notify(User, topic)
  # end
end
