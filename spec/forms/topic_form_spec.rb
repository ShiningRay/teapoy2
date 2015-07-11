require 'rails_helper'

describe TopicForm, type: :model do
  let(:user) { create :active_user }
  it 'creates topic and top_post' do

    f = TopicForm.new(user, Topic.new)

    expect{
      f.validate(title: 'Test', content: 'Form')
      f.save
    }.to change{[Topic.count, Post.count]}
    topic = f.topic
    expect(topic.title).to eq('Test')
    expect(topic.user).to eq(user)
    expect(topic.top_post).to be_valid
    expect(topic.top_post.user).to eq(user)
    expect(topic.top_post.content).to eq('Form')
  end

  it 'updates topic' do
    topic = create :topic, user: user
    f = TopicForm.new(user, topic)

    f.validate(title: 'Test', content: 'Form')
    f.save

    topic.reload

    expect(topic.title).to eq('Test')
    expect(topic.user).to eq(user)
    expect(topic.top_post).to be_valid
    expect(topic.top_post.user).to eq(user)
    expect(topic.top_post.content).to eq('Form')
  end
end