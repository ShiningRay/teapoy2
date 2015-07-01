class Subscription::TopicObserver < Mongoid::Observer
  observe :topic
  def after_create(topic)
    Subscription.notify(Group, topic)
    Subscription.notify(User, topic)
  end
end
