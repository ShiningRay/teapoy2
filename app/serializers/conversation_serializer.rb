class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :owner_id, :target_id, :messages_count
end
