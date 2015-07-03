# coding: utf-8
require 'rails_helper'
require 'sidekiq/testing/inline'

describe Inbox do
	describe 'deliver' do
		let(:group){create(:group)}
		let(:subscriber){create(:user)}
		let(:topic){build(:topic, user:create(:user), group:group)}


		it "should deliver any new topic in user's subscribed group" do
			allow(group).to receive(:preferred_topics_need_approval?).and_return(false)
			allow(subscriber).to receive(:has_subscribed?).with(group).and_return(true)
			allow(subscriber).to receive(:disliked?).with(kind_of(User)).and_return(false)
			topic.save

			Inbox.deliver(subscriber, topic)
			expect(Inbox.by_user(subscriber).size).to eq(1)

			entry = Inbox.by_user(subscriber).last

			expect(entry.topic_id).to eq(topic.id)
			expect(entry.read).to be_falsey
			expect(entry.group_id.to_i).to eq(group.id)
		end

		it 'should deliver any new topic posted by user\' subscribed user' do

		end
	end

	before :each do
		allow_any_instance_of(Group).to receive(:preferred_topics_need_approval?).and_return(false)
	end

	describe '#deliver_repost' do
  	let(:group){create(:group)}
  	let(:reposter){create(:user)}
  	let(:dest_group){create(:group)}
  	let(:topic){create(:topic, user: reposter, group: dest_group)}
  	let(:subscriber){create(:user)}
  	let(:reposted_topic){topic.top_post.repost_to reposter, group.id}

	  context "when subscriber have an empty inbox" do
	  	before(:each)do
	  		Inbox.deliver_repost subscriber, reposted_topic.top_post
	  	end

	  	it "should have the repost in it" do
	  		expect(Inbox.by_user(subscriber).size).to eq(1)
	  		item = Inbox.by_user(subscriber).last
	  		expect(item.post_ids).to include(reposted_topic.top_post.id)
	  		expect(item.repost_ids).to include(topic.top_post.id)
	  		expect(item.topic_id).to eq(reposted_topic.id)
	  	end
	  end

	  context "when subscriber already have the original topic in inbox" do
	  	before do
	  		allow(subscriber).to receive(:has_subscribed?).with(kind_of(Group)).and_return(true)
	  		Inbox.deliver subscriber, topic
	  		Inbox.deliver_repost subscriber, reposted_topic.top_post
	  	end

	  	it "should not have the repost in it" do
	  		expect(Inbox.by_user(subscriber).where(:topic_id => reposted_topic.id)).to be_empty
	  	end

	  	it "should have the repost id in entry for original topic" do
	  		entry = Inbox.by_user(subscriber).where(:topic_id => topic.id).last
	  		expect(entry.repost_ids).to include(reposted_topic.top_post.id)
	  	end
	  end
  end
  describe 'frontpage delivery', broken: true do
  	let(:guest){create(:user)}
  	let(:group){create(:group, hide: false, private: false)}
  	let(:topic){create(:topic, user:create(:user), group:group)}

  	before do
  		allow(User).to receive(:guest){ guest }
  	end

  	it 'should be able to deliver post to guest inbox' do
  		topic.top_post.score = 100
  		guest.stub(:has_read?).with(kind_of(Topic)).and_return(false)
  		Inbox.frontpage_deliver(topic.top_post)
  		expect(Inbox.guest.where(topic_id: topic.id).count).to eq(1)
  	end
  end
  describe 'collection remove_post' do
    it 'should remove post from inbox' do
      #create(:inbox).
    end
  end
end
