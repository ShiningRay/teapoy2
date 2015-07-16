# coding: utf-8
# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  owner_id     :integer          not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#  content      :text(65535)      not null
#  read         :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  target_id    :integer
#
# Indexes
#
#  index_messages_on_owner_id_and_target_id  (owner_id,target_id)
#  owner_id                                  (owner_id,sender_id,read)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    association :owner, factory: :user
    sender { owner }
    association :recipient, factory: :user
    content { Forgery::LoremIpsum.paragraph }
  end
end
