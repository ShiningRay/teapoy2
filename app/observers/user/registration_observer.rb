# -*- coding: utf-8 -*-
class User::RegistrationObserver < ActiveRecord::Observer
  observe :user
  def after_create(user)

  end

  def after_save(user)
    if user.recently_activated?
      UserNotifier.activation(user).deliver
      Message.send_message User.find(1), user, "恭喜您成功激活邮箱，现在开始您就是一个有身份的人了！"
    end
  end
end
