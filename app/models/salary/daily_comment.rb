# coding: utf-8
class Salary::DailyComment < Salary::CountWithMaximum
  self.unit_cost = 1
  self.maximum = 30
  def count
    posts.where(:floor.gt => 0).on_date(created_on).count
  end
end
