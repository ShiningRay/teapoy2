# coding: utf-8
# == Schema Information
#
# Table name: reputations
#
#  id       :integer          not null, primary key
#  user_id  :integer
#  group_id :integer
#  value    :integer          default(0)
#  state    :string(255)      default("neutral")
#  hide     :boolean          default(FALSE)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reputation do
    association :user
    association :group
    value 1
    state "neutral"
  end
end
