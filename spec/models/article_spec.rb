# coding: utf-8
require 'spec_helper'

describe Article do
  it "should be valid" do
    #@article.should be_valid
  end

  describe '.next_in_group .prev_in_group' do
    it "navigates to correct record" do
      #article = Article.find
      articles(:one).next_in_group.should eql(articles(:two))
      articles(:two).prev_in_group.should eql(articles(:one))
    end
  end

  describe "#wrap" do
    context 'give an article object' do
      subject(:article){create :article}
      it "returns article itself directly" do
        Article.wrap(subject).should == subject
      end
    end

    context 'give an article id' do
      it "return article according to id" do
        Article.wrap(subject.id).should == subject
      end
    end
  end
end
