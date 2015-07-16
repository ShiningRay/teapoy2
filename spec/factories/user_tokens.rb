# == Schema Information
#
# Table name: user_tokens
#
#  id           :integer          not null, primary key
#  provider     :string(20)
#  expires_at   :datetime
#  access_token :string(255)
#  secret       :string(255)
#  uid          :string(255)
#  nickname     :string(50)
#  identity_id  :integer
#  user_id      :integer          not null
#
# Indexes
#
#  index_user_tokens_on_provider_and_uid      (provider,uid)
#  index_user_tokens_on_user_id_and_provider  (user_id,provider) UNIQUE
#

FactoryGirl.define do
  factory :user_token do |f|
    provider 'sina'
    user
    uid { Forgery(:basic).text }
    expires_at { 1.week.from_now }
    access_token {Forgery('basic').encrypt}
    secret { Forgery('basic').encrypt }
  end
end
