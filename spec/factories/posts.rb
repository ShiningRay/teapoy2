FactoryGirl.define do
  factory :post do
    content { Forgery::LoremIpsum.paragraph }
  end
end
