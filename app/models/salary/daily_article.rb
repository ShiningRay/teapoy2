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

class Salary::DailyArticle < Salary::CountWithMaximum
  self.unit_cost = 2
  self.maximum = 20
  def count
    Post.top.by_date(created_on).where(user_id: user.id).count
  end
end
