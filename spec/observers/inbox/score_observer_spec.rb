require 'rails_helper'
require 'sidekiq/testing/inline'

# TODO: we have disabled hot top
describe Inbox::ScoreObserver, broken: true do
  let(:guest){create :user, id: 0}
  let(:group){create :group, hide: false, private: false}
  let(:author){create :user}
  let(:top_post) { create(:post, user: author, floor: 0, group: group) }
  let(:topic){Topic.observers.disable :all; create :topic, group: group, user: author, status: 'publish', top_post: top_post}
  let(:subscriber){create :user}

  before do
    Post.observers.disable :all
    Post.observers.enable described_class
    User.stub(:guest).and_return(guest)
    subscriber.subscribe(group)
    guest.stub(:has_read?).with(kind_of(Topic)).and_return(false)
  end

  it 'should deliver post to frontpage' do
    topic.top_post.score=100
    topic.top_post.save
    subscriber.rate 1, topic.top_post
    expect(Inbox.guest.where(:topic_id => topic.id).count).to eq(1)
  end
end
