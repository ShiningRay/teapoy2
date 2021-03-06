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

# other's rating my post
class Salary::DailyScore < Salary
  def self.make(yesterday = Date.yesterday)
    scores = Rating.where('created_at >= ? and created_at < ?', yesterday.beginning_of_day, yesterday.end_of_day).group('post_id').sum('score')
    user_scores = {}
    post_user = {}
    Post.only('id', 'user_id').where(:id.in => scores.keys).each do |p|
      post_user[p.id] = p[:user_id]
    end
    scores.each_pair do |post_id, score|
      uid = post_user[post_id]
      next unless uid
      user_scores[uid] ||= 0
      user_scores[uid] += score
    end
    user_scores.each do |uid, score|
      user = User.find_by_id uid
      next unless user
      begin
        create(:created_on => yesterday, :amount => score / 2, :user_id => uid)
      rescue
        puts 'error'
      end
    end
  end
end
