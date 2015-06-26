
FactoryGirl.define do
  factory :stories do
    association :guestbook
    association :author, factory: :active_user
    content { Forgery::LoremIpsum.text }
  end
end
