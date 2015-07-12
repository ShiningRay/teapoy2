# coding: utf-8
require 'rails_helper'

describe 'Mention Detection' do
  it 'should find out the ids of mentioned user according to login specified after @ symbol' do
    user = create(:user, login: 'test')
    post = build(:post)
    post.content = '@test'
    post.find_mention
    expect(post.mentioned).to include(user.id)
  end

  it 'should find out the ids of mentioned user according to name specified after @ symbol and replace name with login' do
    user = create(:user, login: 'test', name: 'JUST_TEST')
    post = build(:post)
    post.content = '@JUST_TEST'
    post.find_mention
    expect(post.mentioned).to include(user.id)
    expect(post.content).to match( /@test/)
    expect(post.content).not_to match( /JUST_TEST/)
  end

  context "when the user's name is in unicode encoding" do
    let(:user) { create(:user, login: 'test', name: '测试啊')}
    it 'should find out the ids of mentioned user according to name specified after @ symbol' do
      post = build(:post, user: create(:user))
      post.content = "@#{user.name}"
      post.find_mention

      expect(post.mentioned).to include(user.id)
    end
  end

  it 'should found continuous mentions' do
    user1 = create(:user)
    user2 = create(:user)
    author = create(:user)
    post = build(:post, user: author)
    post.content = "@#{user1.login}@#{user2.login}"
    post.find_mention
    expect(post.mentioned).to include(user1.id, user2.id)
  end

  it 'should not include mention to self' do
    user = create(:user, login: 'test')
    post = build(:post, user: user, content: '@test')
    post.find_mention
    expect(post.mentioned).to_not include(user.id)
  end

  it 'should save found mentions after create' do
    user = create(:user, login: 'test')
    author = create(:user)
    group = create(:group)
    topic = Topic.new( :group_id => group.id,
                           :title => 'test',
                           :top_post_attributes => {
                               :content => '@test'})
    topic.user_id = author.id
    topic.save!

    expect(topic.top_post.mentioned).to include(user.id)
  end
end
