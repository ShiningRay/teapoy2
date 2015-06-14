# == Schema Information
#
# Table name: balances
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  charm      :integer          default(0), not null
#  credit     :integer          default(0), not null
#  level      :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :balance do
    user
    trait :rich do
      credit 100
    end
    trait :empty do
      credit 0
    end
    trait :poor do
      credit 10
    end
  end
end
