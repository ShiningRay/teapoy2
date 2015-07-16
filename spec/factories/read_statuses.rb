# == Schema Information
#
# Table name: read_statuses
#
#  id       :integer          not null, primary key
#  user_id  :integer          not null
#  group_id :integer
#  topic_id :integer          not null
#  read_to  :integer          default(0)
#  read_at  :datetime
#  updates  :integer          default(0)
#
# Indexes
#
#  alter_pk     (user_id,group_id,topic_id) UNIQUE
#  total_index  (user_id,group_id,topic_id,read_to)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :read_status do
    association :user
    topic { create :topic }
    group_id { topic.group_id }
    read_to 0
    read_at { Time.now }
    updates 0
  end
end
