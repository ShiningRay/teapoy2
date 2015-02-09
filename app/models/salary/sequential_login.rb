# coding: utf-8
# 连续登录
class Salary::SequentialLogin < Salary
  def self.make(user)
    #连续登录天数
    user = User.wrap(user)
    sequentialLoginCount = 1
    today = Date.today
    Salary::DailyLogin.where("user_id = ? and created_on < ?",user.id,Date.today).order("created_on").limit(6).each do |c|
      unless today-c.created_on != sequentialLoginCount
        sequentialLoginCount += 1
      end
    end
    if sequentialLoginCount > 1
      create(:created_on => today, :amount => sequentialLoginCount, :user_id => user.id)
    end
  end
end
