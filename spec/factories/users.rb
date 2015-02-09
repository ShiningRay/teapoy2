# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	password "1234qwer"
  	password_confirmation "1234qwer"
    state 'pending'
    sequence(:email) {|n| "test#{n}@test.com"}
    sequence(:login) {|n| "test#{n}"}
    sequence(:name) {|n| "test#{n}"}
    trait :active do
      state 'active'
    end
    trait :pending do
      state 'pending'
    end
    trait :admin do
      role {  }
    end
  end
end
