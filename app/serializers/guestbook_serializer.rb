class GuestbookSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner, :description
end
