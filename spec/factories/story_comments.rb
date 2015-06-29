
FactoryGirl.define do
  factory :story_comment do
    association :story
    association :author, factory: :active_user
    content { Forgery::LoremIpsum.text }
  end
end
