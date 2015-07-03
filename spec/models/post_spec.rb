# coding: utf-8
require 'rails_helper'

describe Post, type: :model do
  let(:author) { create :user }
  let(:topic) { create :topic, user: author }
  subject(:post) { topic.top_post }

  describe Post::RatableAspect do
    describe '#rated?' do
      let!(:user) { create :active_user }
      let(:post) { topic.top_post }
      before do
        Rating.create post_id: post.id.to_s, user_id: user.id, score: 1
      end
      it 'tests if user rated the posts' do
        expect(post.rated_by?(user)).to be true
      end
    end
  end

  describe '::MentionsDetection' do
    it "detects @ login" do
      u1 = create(:user)
      p = Post.new
      p.content = "@#{u1.login}"
      p.find_mention
      expect(p.mentioned).to include(u1.id)
    end

    it "doesn't mention author itself" do
      p = Post.new
      p.user = author
      p.content = "@#{author.login}"
      p.find_mention
      expect(p.mentioned).not_to include(author.id)
    end
  end

  describe '::FloorSequence' do
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
  end
end
