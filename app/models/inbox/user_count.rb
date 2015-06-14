# 用户的 Inbox 中的条目数量的计数
# 目的是为了快速找出数量大于1000的 Inbox，然后进行清理，只保留1000条
class Inbox::UserCount
  include Mongoid::Document
  field :user_id, type: Integer
  field :count, type: Integer, default: 0
  index({user_id: 1}, {unique: true})
  index count: 1
  scope :by_user, lambda{|u| where(user_id: u.id)}

  def self.create_or_inc(user_id, amount=1)
    res = where(user_id: user_id).inc(count: amount)
    unless res['updatedExisting']
      create!(user_id: user_id, count: amount)
    end
  end

  def self.count_for(user_id)
    where(user_id: user_id).first.try(:count).to_i
  end

  def self.reset_count
    update_all(count: 0)
  end

  def self.init_data
    User.where('state not in (?)', %w(passive suspended deleted)).find_each do |u|
      create!(user_id: u.id, count: Inbox.by_user(u).count)
    end
  end

  def self.truncate_inbox
    where(:count.gt > 1000).find_each do |c|
      Inbox.by_user(c.user_id).order_by(:score.desc).skip(1000).destroy_all
    end
  end
end
