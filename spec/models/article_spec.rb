# coding: utf-8
require 'rails_helper'

describe Article do

  describe '.next_in_group .prev_in_group' do
    let(:group) { create :group }
    let!(:one) { create :article, group: group, status: 'publish', created_at: 1.minute.ago }
    let!(:two) { create :article, group: group, status: 'publish' }
    it "navigates to correct record" do
      #article = Article.find
      expect(one.next_in_group).to eq(two)
      expect(two.prev_in_group).to eq(one)
    end
  end

  describe "#wrap" do
    subject(:article){create :article}
    context 'give an article object' do
      it "returns article itself directly" do
        expect(Article.wrap(subject)).to eq(subject)
      end
    end

    context 'give an article id' do
      it "return article according to id" do
        expect(Article.wrap(subject.id)).to eq(subject)
      end
    end
  end
end
