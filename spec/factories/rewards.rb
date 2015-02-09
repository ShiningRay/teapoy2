FactoryGirl.define do
  factory :rewards do
    association :winner
    association :rewarder
    association :post
    amount { rand(1..100) }
    created_at

  end
end
