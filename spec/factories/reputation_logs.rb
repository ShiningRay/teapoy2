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
# Indexes
#
#  index_reputation_logs_on_created_on            (created_on)
#  index_reputation_logs_on_group_id_and_user_id  (group_id,user_id)
#  index_reputation_logs_on_post_id               (post_id)
#  index_reputation_logs_on_reputation_id         (reputation_id)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reputation_log do
    association :reputation
    post_id { create(:post).id.to_s }
    amount 1
    reason 'test'
  end
end
