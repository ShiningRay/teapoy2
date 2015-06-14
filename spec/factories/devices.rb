# coding: utf-8
# == Schema Information
#
# Table name: devices
#
#  id        :integer          not null, primary key
#  device_id :string(255)
#  token     :string(255)
#  user_id   :integer
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    id "MyString"
    token "MyString"
  end
end
