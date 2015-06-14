# coding: utf-8
require "spec_helper"

describe ArticleMailer do
  let(:group_owner) { create :user }
  let(:group) { create :group, owner: group_owner }
  context "There's no any article in group" do
    subject(:mail) { described_class.digest_for_group_owner(group) }
    it "should have empty mail" do
      expect(mail.to).to include(group_owner.email)
    end
  end
end
