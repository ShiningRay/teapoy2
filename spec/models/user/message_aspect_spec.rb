# coding: utf-8
require 'spec_helper'

describe User::MessageAspect do
  let!(:sender){ create :user }
  let!(:receiver){ create :user }
  before do
    @out, @in = Message.send_message(sender, receiver, 'test')
  end
  describe '#inbox_messages' do
    it 'has a message' do
      sender.inbox_messages.count.should == 0
      receiver.inbox_messages.count.should == 1
      expect(receiver.inbox_messages).to match_array([@in])
    end
  end

  describe '#unread_messages_count' do
    it 'has a unread message' do
      sender.unread_messages_count.should == 0
      receiver.unread_messages_count.should == 1
    end
  end
end
