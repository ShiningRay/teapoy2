# == Schema Information
#
# Table name: story_comments
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  author_id  :integer          not null
#  content    :text(65535)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_story_comments_on_story_id_and_author_id  (story_id,author_id)
#

class StoryCommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :story
  has_one :author
end
