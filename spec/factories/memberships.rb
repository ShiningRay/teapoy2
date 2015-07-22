

FactoryGirl.define do
  factory :membership do
    association :user
    association :group
  end
end
