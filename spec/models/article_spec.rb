# coding: utf-8
require 'rails_helper'

describe Article do
  let(:group) { create :group }
  subject(:article) { create :article, group: group }
  describe '.next_in_group .prev_in_group' do

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

  describe 'StatusAspect' do
    subject(:article) { create :article, group: group, status: 'pending' }
    before {
      allow_any_instance_of(Article).to receive(:check_after_publish)
      Article.after_publish :check_after_publish
    }

    after {
      Article.skip_callback :publish, :after, :check_after_publish
    }

    it 'publishs article' do
      article.publish!
      expect(article.published?).to be true
    end

    it 'fires after_publish callback' do
      expect(article).to receive(:check_after_publish)
      article.publish!
    end
  end
end
