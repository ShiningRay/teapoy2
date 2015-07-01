class RewardsController < ApplicationController
  # belongs_to :group, :finder => :wrap
  # belongs_to :topic, :finder => :wrap
  respond_to :html, :js, :mobile, :wml
  def create
    @group = Group.wrap params[:group_id]
    topic = @group.public_topics.wrap params[:topic_id]
    @reward = topic.top_post.rewards.new
    @reward.rewarder = current_user
    @reward.post = topic.top_post
    @reward.winner = topic.top_post.original_user
    @reward.amount = 10 if @reward.amount.blank?
    @reward.save!
    respond_with @reward
  end
end
