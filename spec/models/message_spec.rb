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
  describe '::send_message' do
    let!(:sender){ create :user }
    let!(:receiver){ create :user }
    it "create two message" do

      expect{
        Message.send_message(sender, receiver, 'test')
        }.to change{sender.messages.count}.by(1)
      #sender.messages.count.should == 1
      receiver.messages.count.should == 1
      m = receiver.messages.first
      m.read.should be_false
      m.content.should == 'test'
    end
  end

  describe "::send_system_message" do
    pending
  end
end
