FactoryGirl.define do
  factory :conversation do
    association :owner, factory: :user
    association :target, factory: :user
    trait :with_messages do

    end
  end
end
