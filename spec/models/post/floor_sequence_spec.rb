require 'rails_helper'
require 'concurrent'

describe Post::FloorSequence, type: :model do
  let(:topic) { create :topic }

  it "numbers floor correctly" do
    post = Post.new
    post.content = Forgery::LoremIpsum.paragraph
    post.user = create(:user)
    post.topic = topic
    post.parent = topic.top_post
    post.save!

    expect(post.floor).to eq(1)
    post2 = create(:post, topic: topic, parent_id: post.id)
    expect(post2.floor).to eq(2)
  end

  it 'retries next floor when floor clashed' do
    p1 = build_post
    p2 = build_post
    p1.valid?
    p2.valid?
    p1.save!
    p2.save!
    expect(p1.floor).to be_present
    expect(p2.floor).to be_present
  end

  it 'reties next floor when concurrent insert' do
    blk = -> {
      post = build_post
      post.save!
      post
    }
    p1 = Concurrent::Future.execute &blk
    p2 = Concurrent::Future.execute &blk

    sleep(1)

    expect(p1.rejected?).to be false
    expect(p2.rejected?).to be false
  end

  def build_post
    post = Post.new
    post.content = Forgery::LoremIpsum.paragraph
    post.user = create(:user)
    post.topic = topic
    post.parent = topic.top_post
    post
  end
end