# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    association :user, factory: :active_user
    story
  end
end
