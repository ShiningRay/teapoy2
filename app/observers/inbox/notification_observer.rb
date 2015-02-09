# coding: utf-8
class Inbox::NotificationObserver < Mongoid::Observer
  observe :notification
  def after_create(notification)

  end
end
