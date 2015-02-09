# coding: utf-8
class InviteMailer < ActionMailer::Base
  default :from => 'admin@bling0.com'
  layout "mail"
  def invite_to_group(inviter,group,email)
    @inviter = inviter
    @group = group
    mail(:to => email, :subject => "您的好友#{@inviter.name_or_login}邀请您加入圈子 #{@group.name}")
  end

  def invite
  end
end
