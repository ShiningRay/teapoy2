# coding: utf-8
# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string(255)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name { Forgery('internet').user_name }
    trait :admin do
      name 'admin'
    end
  end
end
