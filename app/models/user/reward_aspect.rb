module User::RewardAspect
  extend ActiveSupport::Concern
  included do
    has_many :sent_rewards, :foreign_key => 'rewarder_id', :class_name => 'Reward'
    has_many :winned_rewards, :foreign_key => 'winner_id', :class_name => 'Reward'
  end


  def has_rewarded(post)
    if post
      post = Post.wrap(post)
      Reward.exists?(:rewarder_id => id, :post_id => post.id) if post and !post.id.is_a?(BSON::ObjectId)
    end
  end
  alias has_rewarded? has_rewarded

  def total_winned_rewards
    winned_rewards.sum(:amount)
  end

  def total_sent_rewards
    sent_rewards.sum(:amount)
  end

  def send_reward_for(post, amount)

  end
end
