# coding: utf-8
require 'rails_helper'
require 'sidekiq/testing/inline'

describe Inbox do
	describe 'deliver' do
		let(:group){create(:group)}
		let(:subscriber){create(:user)}
		let(:article){build(:article, user:create(:user), group:group)}
		before(:each) do

		end
		it "should deliver any new article in user's subscribed group" do
			group.stub(:preferred_articles_need_approval?).and_return(false)
			subscriber.stub(:has_subscribed?).with(group).and_return(true)
			subscriber.stub(:disliked?).with(kind_of(User)).and_return(false)
			article.save

			Inbox.deliver(subscriber, article)
			Inbox.by_user(subscriber).size.should == 1

			entry=Inbox.by_user(subscriber).last

			entry.article_id.should == article.id
			entry.read.should be_false
			entry.group_id.should == group.id
		end
		it 'should deliver any new article posted by user\' subscribed user' do
			pending
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
	  		Inbox.by_user(subscriber).size.should == 1
	  		item = Inbox.by_user(subscriber).last
	  		item.post_ids.should include(reposted_article.top_post.id)
	  		item.repost_ids.should include(article.top_post.id)
	  		item.article_id.should == reposted_article.id
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
	  		entry.repost_ids.should include(reposted_article.top_post.id)
	  	end
	  end
  end
  describe 'frontpage delivery' do
  	let(:guest){create(:user, id: 0)}
  	let(:group){create(:group, hide: false, private: false)}
  	let(:article){create(:article, user:create(:user), group:group)}
  	before do
  		User.stub(:guest).and_return(guest)
  	end
  	it 'should be able to deliver post to guest inbox' do
  		article.top_post.score = 100
  		guest.stub(:has_read?).with(kind_of(Article)).and_return(false)
  		Inbox.frontpage_deliver(article.top_post)
  		Inbox.guest.where(article_id: article.id).count.should==1
  	end
  end
  describe "collection remove_post" do
    it "should remove post from inbox" do
      #create(:inbox).
    end
  end
end
