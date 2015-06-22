FactoryGirl.define do
  factory :article do
    title { Forgery(:lorem_ipsum).words(rand(3..10)) }
    association :group
    status 'publish' # usually we're testing published articles
    user { create :user }
    top_post { create(:post, user: user, floor: 0, group: group) }

    after(:create){ |article|
      article.top_post.article = article
      article.top_post.save
    }
  end
end
