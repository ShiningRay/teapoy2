# coding: utf-8
class TopicMailer < ActionMailer::Base
  default :from => 'admin@bling0.com'
  helper :topics
  layout 'mail'

  def digest_for_group_owner(group)
    @group = group
    @user = @group.owner
    return unless @user.preferred_want_receive_notification_email
    today = Date.today
    @date = yesterday = today - 1
    topics = group.public_topics.by_date(@date)
    mail(:to => @user.email, :subject => "[#{topics.size}]#{yesterday.strftime('%Y-%m-%d')}#{group.name}小组情况报告") do |format|
      format.html
      format.text
    end
  end

  def self.deliver_all
    Group.find_each do |g|
      digest_for_group_owner(g).deliver
      sleep 10
    end
  end
end
