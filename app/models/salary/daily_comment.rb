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
# Indexes
#
#  salary  (type,created_on)
#

class Salary::DailyComment < Salary::CountWithMaximum
  self.unit_cost = 1
  self.maximum = 30
  def count
    posts.where(:floor.gt => 0).on_date(created_on).count
  end
end
