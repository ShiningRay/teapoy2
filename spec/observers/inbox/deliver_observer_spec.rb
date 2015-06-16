require 'rails_helper'
require 'sidekiq/testing/inline'

# TODO: we have disabled timeline feature
describe Inbox::DeliverObserver, broken: true do
  let(:group){create :group}
  let(:author){create :user}
  let(:article){build :article, group: group, user: author, status: 'publish'}
  let(:subscriber){create :user}

  before do
    subscriber.subscribe(group)
  end

  it 'delivers article to subscribers after published' do

    expect{
      article.save!
    }.to change{
      Inbox.by_user(subscriber).count
    }.by(1)
    Inbox.by_user(subscriber).first.tap do |i|
      expect(i.article_id).to eq(article.id)
    end
  end
end
