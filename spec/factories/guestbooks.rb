# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guestbook do

    sequence(:name) {|n| "guestbook#{n}"}
    association :owner, factory: :active_user

  end
end
