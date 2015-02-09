# coding: utf-8
module User::NotificationAspect
  extend ActiveSupport::Concern
  included do
    #has_many :notifications
  end
  def notifications
    Notification.where(:user_id => self.id)
  end
end