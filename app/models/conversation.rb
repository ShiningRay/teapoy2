# == Schema Information
#
# Table name: conversations
#
#  id             :integer          not null
#  owner_id       :integer          not null, primary key
#  target_id      :integer          not null, primary key
#  messages_count :integer          default(0)
#  last_content   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#
# Indexes
#
#  index_conversations_on_owner_id_and_target_id  (owner_id,target_id) UNIQUE
#

class Conversation < ActiveRecord::Base
  self.primary_keys = %i(owner_id target_id)
  belongs_to :owner, class_name: 'User'
  belongs_to :target, class_name: 'User'
  has_many :messages, foreign_key: %i(owner_id target_id), dependent: :delete_all
  scope :latest, -> { order('updated_at desc')}
  def unread_count
    @unread_count ||= messages.unread.count
  end
end
