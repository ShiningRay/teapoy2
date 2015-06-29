FactoryGirl.define do
  factory :empty_article, class: Article do
    title { Forgery(:lorem_ipsum).words(rand(3..10), random: true) }
    association :group
    status 'publish' # usually we're testing published articles
    user { create :user }
  end

  factory :article, parent: :empty_article do
    top_post { create(:post, user: user, floor: 0, group: group) }

    after(:create){ |article|
      article.make_top_post
      article.posts_count = 1
      article.save
    }
  end
end
