# coding: utf-8
class User
  module MessageAspect
    extend ActiveSupport::Concern

    included do
      has_many :messages, :foreign_key => 'owner_id'
      has_many :conversations, foreign_key: 'owner_id'
    end

    def inbox_messages
      messages.where("sender_id <> ?", self.id).order("'read' ASC , id DESC  ")
    end

    def outbox_messages
      messages.where(:sender_id => self.id).order('id desc')
    end

    def unread_messages_count
      @unread_messages_count ||= inbox_messages.unread.count
    end
  end
end
