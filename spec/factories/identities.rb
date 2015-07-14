FactoryGirl.define do
  factory :identity do |f|
    provider 'sina'
    uid { Forgery(:basic).text }
    nickname { Forgery(:internet).user_name }
    user_token { create :user_token, provider: provider, uid: uid }
  end
end
