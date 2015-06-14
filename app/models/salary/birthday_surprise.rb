# coding: utf-8
# == Schema Information
#
# Table name: salaries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  amount     :integer
#  type       :string(255)
#  created_on :date
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Salary::BirthdaySurprise < Salary
  def self.make(user)
    today =Date.today
    Rails.logger.debug(user.preferred_birthday.inspect)
    if user.preferred_birthday && user.preferred_birthday.month == today.month && user.preferred_birthday.day == today.day && !Salary::BirthdaySurprise.exists?(["created_on > ? and created_on < ? and user_id = ?",1.year.ago.to_date,today,user.id])
        create(:created_on => today, :amount => 100, :user_id => user.id)
    end
  end
end
