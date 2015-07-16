FactoryGirl.define do
  factory :post do
    topic { create :topic }
    parent_floor 0
    content { Forgery::LoremIpsum.paragraph }
    user { create :user }
    group { create :group }
  end
end
