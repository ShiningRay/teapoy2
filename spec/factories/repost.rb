FactoryGirl.define do
  factory :article do
    title 'test'

  end
  factory :repost do
    post_id 1
    amount 1
  end
end
