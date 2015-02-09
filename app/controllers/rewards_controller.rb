class RewardsController < ApplicationController
  # belongs_to :group, :finder => :wrap
  # belongs_to :article, :finder => :wrap
  respond_to :html, :js, :mobile, :wml
  def create
    @group = Group.wrap params[:group_id]
    @article = @group.public_articles.wrap params[:article_id]
    @reward = @article.top_post.rewards.new
    @reward.rewarder = current_user
    @reward.post = @article.top_post
    @reward.winner = @article.top_post.original_user
    @reward.amount = 10 if @reward.amount.blank?
    @reward.save!
    respond_with @reward
  end
end
