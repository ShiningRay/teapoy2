class StoryCommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :story
  has_one :author
end
