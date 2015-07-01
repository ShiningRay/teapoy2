# coding: utf-8
class Notification::ReplyObserver < Mongoid::Observer
  observe :post
  def after_numbered(reply)
    return if reply.top? or reply.parent.blank?
    parent = reply.parent
    my_id = reply[:user_id]
    commented_user_id = parent[:user_id]
    if my_id != commented_user_id
      commented_topic_id = parent.topic_id

      if commented_user_id && commented_topic_id
        Notification.send_to commented_user_id, 'reply', reply.topic, reply.user, reply
        #Notification.delay.send_to commented_user_id, 'reply', reply.topic, reply.user, reply
      end
    end
  end
end
