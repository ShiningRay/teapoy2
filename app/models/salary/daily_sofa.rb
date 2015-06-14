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

class Salary::DailySofa < Salary::CountWithMaximum
  self.unit_cost = 1
  self.maximum = 15

  def count
    top_posts.on_date(created_on).where(:type.nin => %w(Reward ChangeLog)).count
  end
end
