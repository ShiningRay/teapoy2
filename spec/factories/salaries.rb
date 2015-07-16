# == Schema Information
#
# Table name: salaries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  amount     :integer
#  type       :string(255)
#  created_on :date
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  salary  (type,created_on)
#

FactoryGirl.define do
  factory :salary do
    association :user
    amount { rand(1..10) }
  end
end
