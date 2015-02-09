# coding: utf-8
class GroupMailer < ActionMailer::Base
  default :from => "博聆 <admin@bling0.com>"
  helper :articles
  layout "mail"
  def self.daily_deliver_for_all
    Group.find_each do |g|
      begin
        daily_digest_report(g).deliver
      rescue => e
        $stderr << "send to #{g.name} admin digest report error\n "
        $stderr << e.message
        $stderr << e.backtrace.join("\n")
      end
      sleep 5
    end
  end

  def self.sent_mail_to_all_group_owner
    Group.find_each do |g|
      begin
        sent_mail_to_group_owner(g).deliver
      rescue => e
        $stderr << "send to #{g.name} admin error\n "
        $stderr << e.message
        $stderr << e.backtrace.join("\n")
      end
      sleep 5
    end
  end

  def sent_mail_to_group_owner(g)
     @group = g
     @user = @group.owner
     mail(:to => @user.email, :subject =>  "致小组长的一封信")
  end

  # send a digest report for group owner to know the current status of group
  def daily_digest_report(g)
    @group = g
    @user = @group.owner
    return unless @user.preferred_want_receive_notification_email
    return unless @group.preferred_receive_group_email_frequency == 'day'
    today = Date.today
    yesterday = today - 1
    @date = yesterday
    @articles = @group.articles.where(:created_at => yesterday..today)
    yesterday_memberships = @group.memberships.where('created_at >= ?', today)
    @new_users_count = yesterday_memberships.count
    @new_pending_users_count = yesterday_memberships.where(:role => 'pending').count
    mail(:to => @user.email, :subject =>  "#{@group.name}小组昨日情况报告") do |format|
      format.text
      format.html
    end
  end

  def weekly_digest_report(g)
    @group = g
    @user = @group.owner

    return unless @user.preferred_want_receive_notification_email
    return unless @group.preferred_receive_group_email_frequency == 'week'

    today = Date.today

    if today.wday == 1
      @date = "上一周"
      @articles = @group.articles.where("articles.created_at >= ? AND articles.created_at <= ? ",
        1.week.ago.strftime("%Y-%m-%d"),
        today.strftime("%Y-%m-%d"))
      @new_users_count = Membership.count :conditions => ["group_id =? and created_at >= ? and role = ? ",g.id,1.week.ago.strftime("%Y-%m-%d")]
      @new_pending_users_count = Membership.count :conditions => ["group_id =? and created_at >= ? and role = ?",g.id,1.week.ago.strftime("%Y-%m-%d"),"pending"]
      mail(:to => @user.email, :subject =>  "#{@group.name}小组上一周情况报告")
    end
  end
end
