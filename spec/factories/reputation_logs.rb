# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reputation_log do
    reputation_id 1
    post_id 1
    amount 1
    reason "MyString"
  end
end
