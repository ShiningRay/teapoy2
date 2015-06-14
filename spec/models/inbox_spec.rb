# coding: utf-8
require 'rails_helper'
require 'sidekiq/testing/inline'

describe Inbox do
	describe 'deliver' do
		let(:group){create(:group)}
		let(:subscriber){create(:user)}
		let(:article){build(:article, user:create(:user), group:group)}


		it "should deliver any new article in user's subscribed group" do
			group.stub(:preferred_articles_need_approval?).and_return(false)
			subscriber.stub(:has_subscribed?).with(group).and_return(true)
			subscriber.stub(:disliked?).with(kind_of(User)).and_return(false)
			article.save

			Inbox.deliver(subscriber, article)
			expect(Inbox.by_user(subscriber).size).to eq(1)

			entry = Inbox.by_user(subscriber).last

			expect(entry.article_id).to eq(article.id)
			expect(entry.read).to be_falsey
			expect(entry.group_id.to_i).to eq(group.id)
		end

		it 'should deliver any new article posted by user\' subscribed user' do

		end
	end

	before :each do
		Group.any_instance.stub(:preferred_articles_need_approval?).and_return(false)
	end

	describe "\#deliver_repost" do
  	let(:group){create(:group)}
  	let(:reposter){create(:user)}
  	let(:dest_group){create(:group)}
  	let(:article){create(:article, user: reposter, group: dest_group)}
  	let(:subscriber){create(:user)}
  	let(:reposted_article){article.top_post.repost_to reposter, group.id}

	  context "when subscriber have an empty inbox" do
	  	before(:each)do
	  		Inbox.deliver_repost subscriber, reposted_article.top_post
	  	end

	  	it "should have the repost in it" do
	  		expect(Inbox.by_user(subscriber).size).to eq(1)
	  		item = Inbox.by_user(subscriber).last
	  		expect(item.post_ids).to include(reposted_article.top_post.id)
	  		item.repost_ids.should include(article.top_post.id)
	  		expect(item.article_id).to eq(reposted_article.id)
	  	end
	  end

	  context "when subscriber already have the original article in inbox" do
	  	before do
	  		subscriber.stub(:has_subscribed?).with(kind_of(Group)).and_return(true)
	  		Inbox.deliver subscriber, article
	  		Inbox.deliver_repost subscriber, reposted_article.top_post
	  	end

	  	it "should not have the repost in it" do
	  		Inbox.by_user(subscriber).where(:article_id => reposted_article.id).should be_empty
	  	end

	  	it "should have the repost id in entry for original article" do
	  		entry = Inbox.by_user(subscriber).where(:article_id => article.id).last
	  		expect(entry.repost_ids).to include(reposted_article.top_post.id)
	  	end
	  end
  end
  describe 'frontpage delivery', broken: true do
  	let(:guest){create(:user)}
  	let(:group){create(:group, hide: false, private: false)}
  	let(:article){create(:article, user:create(:user), group:group)}

  	before do
  		allow(User).to receive(:guest){ guest }
  	end

  	it 'should be able to deliver post to guest inbox' do
  		article.top_post.score = 100
  		guest.stub(:has_read?).with(kind_of(Article)).and_return(false)
  		Inbox.frontpage_deliver(article.top_post)
  		expect(Inbox.guest.where(article_id: article.id).count).to eq(1)
  	end
  end
  describe "collection remove_post" do
    it "should remove post from inbox" do
      #create(:inbox).
    end
  end
end
