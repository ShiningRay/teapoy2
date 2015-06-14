require 'rails_helper'
require 'sidekiq/testing/inline'

describe Inbox::DeliverObserver do
  let(:group){create :group}
  let(:author){create :user}
  let(:article){build :article, group: group, user: author, status: 'publish'}
  let(:subscriber){create :user}
  before do
    subscriber.subscribe(group)
  end

  it 'should deliver article to subscribers after published' do
    article.save!
    expect(Inbox.by_user(subscriber).count).to eq(1)
    Inbox.by_user(subscriber).first.tap do |i|
      expect(i.article_id).to eq(article.id)
    end
  end
end
