class StorySerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :guestbook
  has_one :author
end
