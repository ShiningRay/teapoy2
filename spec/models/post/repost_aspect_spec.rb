require 'rails_helper'
require 'sidekiq/testing/inline'

describe Post, :broken => true do
	let(:author){create(:user)}
	let(:group){create(:group)}
	let(:article){ create(:article, group: group, user: author)}
	let(:sharer){create(:user)}
	let(:dest_group){
		create(:group).tap{|group|
			group.stub(:preferred_articles_need_approval?).and_return(false)
		}
	}
	it 'should be posted to another group successfully' do
		reposted = article.top_post.repost_to sharer,dest_group.id
		reposted.status.should == 'publish'
		reposted.title.should be_blank
		reposted.user_id.should == sharer.id
		reposted.group_id.should == dest_group.id
		article.top_post.reposted_to?(dest_group)
		article.top_post.has_repost?.should be_true
	end

	it 'should not be reposted to the same group twice' do
		pending
	end

end