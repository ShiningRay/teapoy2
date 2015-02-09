FactoryGirl.define do
  factory :articles do
    title { Forgery(:lorem_ipsum).words(rand(3..10)) }
    association :user
    association :group
    status { Article::STATUSES.sample }
    top_post { create(:post, user: user, floor: 0, group: group) }
    #after(:create){ |article|
    #  article.top_post.article_id = article.id
    #}
  end
end
