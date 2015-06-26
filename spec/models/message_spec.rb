# coding: utf-8
# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  owner_id     :integer          not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#  content      :text             not null
#  read         :boolean          default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  target_id    :integer
#

require 'rails_helper'

describe Message do
  let!(:sender){ create :user }
  let!(:receiver){ create :user }

  describe '::send_message' do
    it "create two message" do
      expect{
        Message.send_message(sender, receiver, 'test')
      }.to change{sender.messages.count}.by(1)
      # expect(#sender.messages.count).to eq(1)
      expect(receiver.messages.count).to eq(1)
      m = receiver.messages.first
      expect(m.read).to be_falsey
      expect(m.content).to eq('test')
    end
  end

  describe '.send_system_message' do
    it 'sends a system message' do
      expect {
        Message.send_system_message(receiver, 'test')
      }.to change(Message, :count).by(1)
    end
  end
end
