FactoryGirl.define do
  factory :post do
    content { Forgery::LoremIpsum.paragraph }
    user { create :user }
    group { create :group }

    before(:create) { |post|
      post.floor = 0 if post.article.blank?
      post.parent = post.article.top_post unless post.floor == 0
    }
  end
end
