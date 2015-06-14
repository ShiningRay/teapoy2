# == Schema Information
#
# Table name: references
#
#  id            :integer          not null, primary key
#  source_id     :integer
#  target_id     :integer
#  relation_type :string(255)
#  detected      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reference do
  end
end
