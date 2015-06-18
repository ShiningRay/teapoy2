# coding: utf-8
# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  subscriber_id    :integer
#  publication_id   :integer
#  publication_type :string(32)
#  viewed_at        :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  unread_count     :integer          default(0), not null
#

require 'rails_helper'

describe Subscription do
  describe '.notify' do
    let(:subscriber) { create :user }
    let(:publication) { create :group }
    subject(:subscription) { create :subscription, user: subscriber, publication: publication }

    it "update timestamp and unread count" do
      expect{
        Subscription.notify(publication.class, publication)
      }
    end
  end
end
