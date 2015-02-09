# coding: utf-8
# rating other's post
class Salary::DailyRating < Salary::CountWithMaximum
  self.unit_cost = 1
  self.maximum = 50

  def count
    user.ratings.where("created_at > ? and created_at < ?", created_on.beginning_of_day, created_on.end_of_day).size
  end
end
