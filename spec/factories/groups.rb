# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    sequence(:alias) {|n| "test#{n}"}
    sequence(:name) {|n| "testgroup#{n}"}
    association :owner, factory: :active_user
    theme { ENV['THEME'] }
  end
end
