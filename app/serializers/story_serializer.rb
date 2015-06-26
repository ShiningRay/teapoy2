class StorySerializer < ActiveModel::Serializer
  attributes :id, :body
  has_one :guestbook
  has_one :author
end
