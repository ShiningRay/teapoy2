require 'spec_helper'
require 'sidekiq/testing/inline'

describe Inbox::ScoreObserver do
  let(:guest){create :user, id: 0}
  let(:group){create :group, hide: false, private: false}
  let(:author){create :user}
  let(:top_post) { create(:post, user: author, floor: 0, group: group) }
  let(:article){Article.observers.disable :all; create :article, group: group, user: author, status: 'publish', top_post: top_post}
  let(:subscriber){create :user}
  before do
    Post.observers.disable :all
    Post.observers.enable described_class
    User.stub(:guest).and_return(guest)
    subscriber.subscribe(group)
    guest.stub(:has_read?).with(kind_of(Article)).and_return(false)
  end

  it 'should deliver post to frontpage' do
    article.top_post.score=100
    article.top_post.save
    subscriber.rate 1, article.top_post
    Inbox.guest.where(:article_id => article.id).count.should == 1
  end
end