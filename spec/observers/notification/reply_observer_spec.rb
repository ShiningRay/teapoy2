require 'rails_helper'
require 'sidekiq/testing/inline'

describe Notification::ReplyObserver do
  before { Mongoid.observers.enable Notification::ReplyObserver }
  before do
    mail = double("Mail", :deliver => true)
    allow_any_instance_of(User).to receive(:preferred_want_receive_notification_email?).and_return(false)
    allow(UserNotifier).to receive(:notify).and_return(mail)
  end

  let(:original_poster) { create(:user) }
  let(:replier) { create(:user) }
  let(:article) {
    article = Article.new group_id: create(:group).id,
                          top_post_attributes: {
                            content: Forgery::LoremIpsum.paragraph
                          }
    article.user_id = original_poster.id
    article.status = 'publish'
    article.save!
    article
  }
  let(:original_post) { article.top_post }

  subject(:reply) {
    reply = Post.new
    reply.article = article
    reply.parent = original_post
    reply.group_id = article.group_id
    reply.content = Forgery::LoremIpsum.paragraph
    reply.user = replier
    reply
  }

  it "should observe reply and send a notification to replied user" do
    expect{
      reply.save!
    }.to change{original_poster.notifications.count}.by(1)

    n = original_poster.notifications.first
    expect(n.subject).to eq(article)
  end

  context "when there is already a notification of that article in box" do
    before{ reply.save! }
    let(:another_reply){
      build :post, article: article, parent: original_post
    }
    it "should not generate another notification "  do
      expect{
        another_reply.save
      }.not_to change{original_poster.notifications.count}
    end
  end
end
