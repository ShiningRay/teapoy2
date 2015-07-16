# == Schema Information
#
# Table name: identities
#
#  id       :integer          not null, primary key
#  provider :string(15)       not null
#  uid      :string(255)      not null
#  nickname :string(50)
#
# Indexes
#
#  index_identities_on_provider_and_uid  (provider,uid) UNIQUE
#

FactoryGirl.define do
  factory :identity do |f|
    provider 'sina'
    uid { Forgery(:basic).text }
    nickname { Forgery(:internet).user_name }
    user_token { create :user_token, provider: provider, uid: uid }
  end
end
