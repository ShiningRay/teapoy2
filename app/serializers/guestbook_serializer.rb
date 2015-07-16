# == Schema Information
#
# Table name: guestbooks
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  owner_id    :integer          not null
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_guestbooks_on_name      (name) UNIQUE
#  index_guestbooks_on_owner_id  (owner_id)
#

class GuestbookSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner, :description
end
