# coding: utf-8
require 'rails_helper'

describe Subscription do
  describe '.notify' do
    let(:subscriber){ create :user }
    let(:publication) { create :group }
    subject() { create :subscription, user: subscriber, publication: publication }
    it "update timestamp and unread count" do
      pending
    end
  end
end
