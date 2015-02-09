# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    subscriber { create :user }
    unread_count 0
    updated_at Time.at(0)
  end
end
