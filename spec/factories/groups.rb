# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do |f|
    f.alias { Forgery(:internet).user_name }
    name { self.alias }
    association :owner, factory: :active_user
    theme { ENV['THEME'] }
  end
end
