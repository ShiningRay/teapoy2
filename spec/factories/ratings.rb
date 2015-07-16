# coding: utf-8
# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  post_id    :integer          default(0), not null
#  user_id    :integer          default(0), not null
#  score      :integer          default(0), not null
#  created_at :datetime         not null
#
# Indexes
#
#  created_at                               (created_at)
#  index_ratings_on_article_id_and_user_id  (post_id,user_id) UNIQUE
#  index_ratings_on_score                   (score)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    association :user, factory: :active_user
    post_id { create(:topic).top_post.id.to_s }
    score { [-1, 1].sample }
  end
end
