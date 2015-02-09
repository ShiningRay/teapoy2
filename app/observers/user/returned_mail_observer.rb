# coding: utf-8
class User::ReturnedMailObserver < ActiveRecord::Observer
  observe :user
  def address_not_exists(user)
    if user.state == 'active'
      user.state = 'pending'
      user.save!
    end
    Message.send_message(User.find(1), user, "很抱歉我们无法给您的邮箱#{user.email}投递邮件，请您更改邮箱后重新激活")
  end

  def mail_rejected(user)
    Message.send_message(User.find(1), user, "我们的系统发现无法向您的邮箱#{user.email}投递通知邮件，可能是因为您将我们的邮箱地址加入了黑名单，我们建议您将博聆的邮箱地址从黑名单中移出，如果是因为通知邮件太多，可以在网站设置中将其关闭")
    user.preferred_want_receive_notification_email = false
    user.save
  end
end
