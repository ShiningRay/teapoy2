# coding: utf-8
# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    association :user, factory: :active_user
    post_id { create(:topic).top_post.id.to_s }
    score { [-1, 1].sample }
  end
end
