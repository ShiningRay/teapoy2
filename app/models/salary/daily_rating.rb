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

# rating other's post
class Salary::DailyRating < Salary::CountWithMaximum
  self.unit_cost = 1
  self.maximum = 50

  def count
    user.ratings.where("created_at > ? and created_at < ?", created_on.beginning_of_day, created_on.end_of_day).size
  end
end
