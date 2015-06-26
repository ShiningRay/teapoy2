# coding: utf-8
require 'rails_helper'

describe Post do
  let(:author) { create :user }
  let(:article) { create :article, user: author }
  subject(:post) { article.top_post }

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
    let(:article) { create :article }

    it "numbers floor correctly" do
      post = Post.new
      post.content = Forgery::LoremIpsum.paragraph
      post.user = create(:user)
      post.article = article
      post.parent = article.top_post
      post.save!
      expect(post.floor).to eq(1)
      post2 = create(:post, article: article, parent_id: post.id)
      expect(post2.floor).to eq(2)
    end
  end
end
