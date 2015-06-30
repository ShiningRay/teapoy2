# coding: utf-8
require 'rails_helper'

describe Notification::MentionObserver do
  let(:mentioned_user){create(:user)}
  let(:author) { create :user }
  let(:topic){
    Topic.new group_id: create(:group).id,
            user_id: author.id,
            status: 'publish',
            top_post_attributes: {
              user_id: author.id,
              content: "@#{mentioned_user.login}",
              floor: 0
            }
  }

  before {Mongoid.observers.enable Notification::MentionObserver}

  it 'sends notification to mentioned user after topic save' do
    expect{
      topic.save
    }.to change{ Notification.count }
  end

  it 'sends notification to mentioned user after reply save' do
    expect do
      topic.top_post.content = 'No mention'
      topic.save!
      post = Post.new
      post.user_id = create(:user).id
      post.content = "@#{mentioned_user.login}"
      post.parent = topic.top_post
      post.topic_id= topic.id
      post.save
    end.to change{Notification.count}

  end

  it 'should not send information to mentioned user if topic is not published' do
    expect{
      topic.status = 'pending'
      topic.save
    }.not_to change{Notification.count}
  end
end
