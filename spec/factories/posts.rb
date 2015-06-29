FactoryGirl.define do
  factory :post do
    content { Forgery::LoremIpsum.paragraph }
    user { create :user }
    group { create :group }
  end
end
