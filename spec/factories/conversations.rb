# == Schema Information
#
# Table name: conversations
#
#  id             :integer          not null
#  owner_id       :integer          not null, primary key
#  target_id      :integer          not null, primary key
#  messages_count :integer          default(0)
#  last_content   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_conversations_on_owner_id_and_target_id  (owner_id,target_id) UNIQUE
#

FactoryGirl.define do
  factory :conversation do
    association :owner, factory: :user
    association :target, factory: :user
    trait :with_messages do

    end
  end
end
