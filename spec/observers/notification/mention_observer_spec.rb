# coding: utf-8
require 'rails_helper'

describe Notification::MentionObserver do
  let(:mentioned_user){create(:user)}
  let(:author) { create :user }
  let(:article){
    Article.new group_id: create(:group).id,
            user_id: author.id,
            status: 'publish',
            top_post_attributes: {
              user_id: author.id,
              content: "@#{mentioned_user.login}",
              floor: 0
            }
  }

  before {Mongoid.observers.enable Notification::MentionObserver}

  it "sends notification to mentioned user after article save" do
    expect{
      article.save
    }.to change{ Notification.count }
  end

  it "sends notification to mentioned user after reply save" do
    expect do
      article.top_post.content = 'No mention'
      article.save!
      post = Post.new
      post.user_id = create(:user).id
      post.content = "@#{mentioned_user.login}"
      post.parent = article.top_post
      post.article_id= article.id
      post.save
    end.to change{Notification.count}

  end

  it "should not send information to mentioned user if article is not published" do
    expect{
      article.status = 'pending'
      article.save
    }.not_to change{Notification.count}
  end
end
