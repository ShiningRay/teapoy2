
FactoryGirl.define do
  factory :story do
    association :guestbook
    association :author, factory: :active_user
    content { Forgery::LoremIpsum.text }
  end
end
