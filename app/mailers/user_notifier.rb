# -*- coding: utf-8 -*-
class UserNotifier < ActionMailer::Base
  default :from => '博聆 <admin@bling0.com>'
  helper :notifications, :articles
  layout "mail"

  def notify(notification)
    @user = notification.user
    @notification = notification
    mail :to => @user.email, :subject => '您在博聆网有一条新通知'do |format|
      format.html
      format.text
    end
  end

  def notify_everyday_notification(user)
    @user = user
    @notifications = user.notifications.unread
    mail :to => @user.email, :subject => '您今日的提醒汇总'
  end

  def magazine(user)
    mail :to => user.email, :subject => '博聆《潮音》006期'
  end

  def send_to_someone(user,title,content)
    @content = content
    mail :to => user.email, :subject => title do |format|
      format.html { render "send_to_someone" }
    end
  end

  def digest_notify(user)

  end

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail :to => user.email,
         :subject => "重置密码"
  end

  def signup_notification(user)
    @user = user
    mail :to => user.email, :subject => '请激活您的帐号'
  end

  def activation(user)
    @user = user
    mail :to => user.email , :subject => '您的帐号已经被成功激活' do |format|
      format.html
      format.text
    end
  end

  def noticemail(user, text, title=nil)
    setup_email_gen( title )
    recipients user.email
    body :username => user.login, :text => text
  end

  def digest_notification(user, articles, comments)
    recipients user.email
    subject     "您关注的帖子今日有更新"
    sent_on     Time.now
    body :user => user, :articles => articles, :comments => comments
  end

  def recall_mail(user)
    @user = user
    mail :to => user.email , :subject => "您好久没来博聆看看了呢" do |format|
      format.html
      format.text
    end
  end

  def self.send_recall_mails
    User.where('last_login_at < NOW()-INTERVAL 1 month').find_each do |user|
      recall_mail(user).deliver
    end
  end

  def suspend(user)
    recipients user.email
    mail :to => user.email, :subject => "您的帐号已被冻结" do |format|
      format.html
      format.text
    end
  end
end
