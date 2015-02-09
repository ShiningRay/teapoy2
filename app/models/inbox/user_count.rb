class Inbox::UserCount
  include Mongoid::Document
  field :user_id, type: Integer
  field :count, type: Integer, default: 0
  index({user_id: 1}, {unique: true})
  index count: 1
  scope :by_user, lambda{|u| where(user_id: u.id)}

  def self.create_or_inc(user_id, amount=1)
    unless where(user_id: user_id).inc(:count, amount)
      create!(user_id: user_id, count: 1)
    end
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

