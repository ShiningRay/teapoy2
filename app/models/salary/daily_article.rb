# coding: utf-8
class Salary::DailyArticle < Salary::CountWithMaximum
  self.unit_cost = 2
  self.maximum = 20
  def count
    Post.top.by_date(created_on).where(user_id: user.id).count
  end
end
