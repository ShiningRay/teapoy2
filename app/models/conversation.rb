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
