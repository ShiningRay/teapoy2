# coding: utf-8
require 'rails_helper'

describe User::MessageAspect do
  let!(:sender){ create :user }
  let!(:receiver){ create :user }

  before do
    @out, @in = Message.send_message(sender, receiver, 'test')
  end

  describe '#inbox_messages' do
    it 'has a message' do
      expect(sender.inbox_messages.count).to eq(0)
      expect(receiver.inbox_messages.count).to eq(1)
      expect(receiver.inbox_messages).to match_array([@in])
    end
  end

  describe '#unread_messages_count' do
    it 'has a unread message' do
      expect(sender.unread_messages_count).to eq(0)
      expect(receiver.unread_messages_count).to eq(1)
    end
  end
end
