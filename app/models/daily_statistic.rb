# coding: utf-8
class DailyStatistic < ActiveRecord::Base

  def self.make_today_record
   today = Date.today
   login_count = User.count :all, :conditions => ['updated_at >= ? and updated_at <= ?',today.beginning_of_day , (today+1).beginning_of_day]
   create(:record_data => Time.zone.parse(today.to_time.to_s), :login_count => login_count)
  end

end

