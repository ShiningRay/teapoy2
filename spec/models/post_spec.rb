# coding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe Post do
  before(:each) do
    #@article = Article.new
  end

  it "should be able to detect @ login" do
    pending
    user = mock_model(User)
    User.should_receive(:wrap).and_return(user)
    User.should_receive(:find_by_name).and_return(user)
    #Post.
  end
  it "should number floor sequence correctly" do
    article = create(:article)
    post = build(:post, article: article, parent_id: 0)
    post.save!
    post.floor.should == 1
    post2 = create(:post, article: article, parent_id: 1)
    post2.floor.should == 2
  end
end
