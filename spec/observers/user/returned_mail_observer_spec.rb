require 'spec_helper'

describe User::ReturnedMailObserver do
  let(:user) { create :user }
  before do
    User.add_observer described_class.instance
    User.observers.enable described_class
    @admin = create :user, :id => 1
  end

  it "should send a message and make user pending when email address not exists" do
    User.notify_observers :address_not_exists, user
    #described_class.instance.address_not_exists(user)
    user.inbox_messages.should_not be_empty
    user.state.should == 'pending'
  end

  it "should send a message and set user preferrences to not to receive email" do
    User.notify_observers :mail_rejected, user
    #described_class.instance.mail_rejected user
    user.inbox_messages.should_not be_empty
    user.preferred_want_receive_notification_email.should be_false
  end
end
