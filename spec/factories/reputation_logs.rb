# coding: utf-8
# == Schema Information
#
# Table name: reputation_logs
#
#  id            :integer          not null, primary key
#  reputation_id :integer
#  user_id       :integer
#  group_id      :integer
#  post_id       :string(24)       default("0"), not null
#  amount        :integer
#  reason        :string(255)
#  created_on    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reputation_log do
    reputation_id 1
    post_id 1
    amount 1
    reason "MyString"
  end
end
