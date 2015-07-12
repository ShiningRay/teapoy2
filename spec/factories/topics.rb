FactoryGirl.define do
  factory :empty_topic, class: Topic do
    title { Forgery(:lorem_ipsum).words(rand(3..10), random: true) }
    association :group
    status 'publish' # usually we're testing published topics
    association :user
    anonymous false
  end

  factory :topic, parent: :empty_topic do
    top_post { create(:post, user: user, floor: 0, group: group) }
    content {  Forgery::LoremIpsum.paragraph }
    after(:create){ |topic|
      topic.make_top_post
      topic.posts_count = 1
      topic.save
    }
  end
end
