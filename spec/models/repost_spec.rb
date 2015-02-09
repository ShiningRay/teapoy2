# coding: utf-8
require 'spec_helper'

describe Repost do
  before(:each) do
    @repost = create :post
  end

  it "should not be able to repost to own group" do
    articles(:one).next_in_group.should eql(articles(:two))
  end

  it "should be valid" do
    @rating.should be_valid
  end
end
