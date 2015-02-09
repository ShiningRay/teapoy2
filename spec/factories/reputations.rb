# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reputation do
    user_id 1
    group_id 1
    value 1
    state ""
  end
end
