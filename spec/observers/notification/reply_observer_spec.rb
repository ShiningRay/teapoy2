require 'spec_helper'
require 'sidekiq/testing/inline'

describe Notification::ReplyObserver do
  before :each do
    Post.observers.enable Notification::ReplyObserver
  end
  it "should observe reply and send a notification to replied user" do
    mail = stub(:deliver)
    User.any_instance.stub(:preferred_want_receive_notification_email?).and_return(false)
    UserNotifier.stub(:notify).and_return(mail)
    original_poster =  create(:user)
    replier = create(:user)
    article = Article.new group_id: create(:group).id,
                          top_post_attributes: {
                            content: Forgery::LoremIpsum.paragraph
                          }
    article.user_id = original_poster.id
    article.status = 'publish'
    article.save!
    original_post = article.top_post

    reply = build(:post).tap{|reply|
      reply.article = article
      reply.parent_id = original_post.floor
      reply.group_id = article.group_id
      reply.content = Forgery::LoremIpsum.paragraph
      reply.user = replier
    }
    reply.save!
    $stderr << Article.find(1).inspect << "\n"
    original_poster.notifications.count.should == 1

    n = original_poster.notifications.first
    $stderr << article.inspect << "\n"
    $stderr << n.inspect << "\n"
    n.subject.should == article
  end
  context "when there is already a notification of that article in box" do
    it "should not generate another notification "  do
      pending
    end
  end
end
