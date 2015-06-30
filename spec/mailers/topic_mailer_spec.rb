# coding: utf-8
require 'rails_helper'

describe TopicMailer do
  let(:group_owner) { create :user }
  let(:group) { create :group, owner: group_owner }
  context "There's no any topic in group" do
    subject(:mail) { described_class.digest_for_group_owner(group) }
    it 'should have empty mail' do
      expect(mail.to).to include(group_owner.email)
    end
  end
end
