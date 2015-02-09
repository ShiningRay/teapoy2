FactoryGirl.define do
  factory :balance do
    user
    trait :rich do
      credit 100
    end
    trait :empty do
      credit 0
    end
    trait :poor do
      credit 10
    end
  end
end
