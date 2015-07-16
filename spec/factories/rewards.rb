# == Schema Information
#
# Table name: rewards
#
#  id          :integer          not null, primary key
#  rewarder_id :integer          not null
#  post_id     :integer          not null
#  winner_id   :integer          not null
#  amount      :integer
#  anonymous   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_rewards_on_rewarder_id_and_post_id  (rewarder_id,post_id) UNIQUE
#

FactoryGirl.define do
  factory :reward do
    association :winner, factory: :user
    association :rewarder, factory: :rich_user
    association :post, factory: :post
    amount { rand(1..100) }
  end
end
