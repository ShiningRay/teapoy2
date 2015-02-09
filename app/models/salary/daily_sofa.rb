# coding: utf-8
class Salary::DailySofa < Salary::CountWithMaximum
  self.unit_cost = 1
  self.maximum = 15

  def count
    top_posts.on_date(created_on).where(:type.nin => %w(Reward ChangeLog)).count
  end
end
