# coding: utf-8
# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  story_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_likes_on_story_id_and_user_id  (story_id,user_id) UNIQUE
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    association :user, factory: :active_user
    story
  end
end
