# coding: utf-8
class Reputation::PostObserver < Mongoid::Observer
  observe :post

  def after_destroy(post)
    return unless post.original_user
    return unless post.top?
    ReputationLog.where(:user_id=>post.read_attribute(:user_id),:post_id=>post.id).each do |c|
      post.original_user.gain_reputation(-c.amount, post, 'topic_deleted')
    end
  end
  #handle_asynchronously :after_destroy #if Rails.env.production?
end
