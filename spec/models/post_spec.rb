# coding: utf-8
# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  content        :text(65535)      not null
#  user_id        :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  parent_id      :integer
#  ip             :integer          default(0), not null
#  group_id       :integer
#  topic_id       :integer          default(0), not null
#  floor          :integer
#  neg            :integer          default(0), not null
#  pos            :integer          default(0), not null
#  score          :integer          default(0), not null
#  anonymous      :boolean          default(FALSE), not null
#  status         :string(255)      default(""), not null
#  ancestry       :string(255)      default(""), not null
#  ancestry_depth :integer          default(0), not null
#  parent_floor   :integer
#  mentioned      :string(255)
#
# Indexes
#
#  article_id                                (topic_id,floor) UNIQUE
#  index_posts_on_ancestry                   (ancestry)
#  index_posts_on_reshare_and_parent_id      (parent_id)
#  index_posts_on_topic_id_and_parent_floor  (topic_id,parent_floor)
#  pk                                        (group_id,topic_id,floor) UNIQUE
#

require 'rails_helper'
# require 'concurrent'

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

    it 'retries next floor when floor clashed' do
      # p1 = Concurrent::Promise.new{ build_post.save! }
      # p2 = Concurrent::Promise.new{ build_post.save! }
      # expect(Concurrent::Promise.all?(p1, p2)).to be true
      p1 = build_post
      p2 = build_post
      p1.valid?
      p2.valid?
      p1.save!
      p2.save!
      expect(p1.floor).to be_present
      expect(p2.floor).to be_present
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

  describe '.attachment_ids' do
    context 'when creating post' do
      before {
        @topic = create :topic
        @p = Post.new user: author, topic: @topic, content: 'test'
        @attachment = create :attachment, uploader_id: author.id
      }
      it 'associates attachments after saved' do
        @p.attachment_ids = [@attachment.id.to_s]
        @p.save
        expect(@p.attachments).to match([@attachment])
      end

      it 'does not associate the attachments which are already associated' do
        attachment2 = create :attachment, post: post, uploader_id: author.id
        @p.attachment_ids = [@attachment.id.to_s, attachment2.id.to_s]
        @p.save
        expect(@p.attachments).to match([@attachment])
      end
    end
  end
end
