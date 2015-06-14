# coding: utf-8
# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  owner_id     :integer          not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#  content      :text             not null
#  read         :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  target_id    :integer
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do

  end
end
