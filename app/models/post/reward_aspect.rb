module Post::RewardAspect
  extend ActiveSupport::Concern
  included do
    t_has_many :rewards, foreign_key: :post_id
    #field :total_rewards, type: Integer
    #has_and_belongs_to_many :rewarders, class: 'User'#, :through => :rewards
  end

  def rewarders
    User.where(id: rewards.map(&:rewarder_id))
  end

  def total_rewards
    rewards.sum(:amount)
  end

  def new_reward attrs={}
    attrs[:post_id] = self.id
    Reward.new attrs
  end
end
