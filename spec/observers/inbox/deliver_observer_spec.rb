require 'rails_helper'
require 'sidekiq/testing/inline'

# TODO: we have disabled timeline feature
describe Inbox::DeliverObserver, broken: true do
  let(:group){create :group}
  let(:author){create :user}
  let(:topic){build :topic, group: group, user: author, status: 'publish'}
  let(:subscriber){create :user}

  before do
    subscriber.subscribe(group)
  end

  it 'delivers topic to subscribers after published' do

    expect{
      topic.save!
    }.to change{
      Inbox.by_user(subscriber).count
    }.by(1)
    Inbox.by_user(subscriber).first.tap do |i|
      expect(i.topic_id).to eq(topic.id)
    end
  end
end
