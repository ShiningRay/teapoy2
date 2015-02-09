# coding: utf-8
class Salary::BirthdaySurprise < Salary
  def self.make(user)
    today =Date.today
    Rails.logger.debug(user.preferred_birthday.inspect)
    if user.preferred_birthday && user.preferred_birthday.month == today.month && user.preferred_birthday.day == today.day && !Salary::BirthdaySurprise.exists?(["created_on > ? and created_on < ? and user_id = ?",1.year.ago.to_date,today,user.id])
        create(:created_on => today, :amount => 100, :user_id => user.id)
    end
  end
end
