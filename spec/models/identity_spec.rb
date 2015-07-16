# == Schema Information
#
# Table name: identities
#
#  id       :integer          not null, primary key
#  provider :string(15)       not null
#  uid      :string(255)      not null
#  nickname :string(50)
#
# Indexes
#
#  index_identities_on_provider_and_uid  (provider,uid) UNIQUE
#

require 'rails_helper'

describe Identity, type: :model do
  describe '.followers' do
    let(:id1) { create :identity }
    let(:id2) { create :identity }
    before {
      id1.followerships.create follower_uid: id2.uid
    }
    it 'gets followers' do
      expect(id1.followers).to match([id2])
      # expect(id2.followings).to match([id1])
    end
  end
end
