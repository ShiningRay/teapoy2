# coding: utf-8
require 'rails_helper'

describe Notification::MentionObserver do
  let(:mentioned_user){create(:user)}
  let(:article){
    a = Article.new group_id: create(:group).id,
                top_post_attributes: {
                  content: "@#{mentioned_user.login}"
                }
    a.user_id = create(:user).id
    a.top_post.user_id = a.user_id
    a.status = 'publish'
    a
  }

  it "should send notification to mentioned user after article save" do
    expect(Notification).to receive(:send_to).with(mentioned_user.id, 'mention', article, article.user, article.top_post).and_return(nil)
    article.save
    article.top_post.mentioned.should include(mentioned_user.id)
  end

  it "should send notification to mentioned user after reply save" do
    article.top_post.content = 'No mention'
    article.save!
    post = Post.new
    post.user_id = create(:user).id
    post.content = "@#{mentioned_user.login}"
    post.parent_id = 0
    post.article_id= article.id
    expect(Notification).to receive(:send_to).with(mentioned_user.id, 'mention', article, post.user, post).and_return(nil)
    post.save

    expect(post.mentioned).to include(mentioned_user.id)
  end

  it "should not send information to mentioned user if article is not published" do
    #a.status = 'pending'
    pending
  end
end
