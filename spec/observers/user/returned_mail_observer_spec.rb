require 'rails_helper'

describe User::ReturnedMailObserver, broken: true do
  let(:user) { create :user }
  before do
    User.add_observer described_class.instance
    User.observers.enable described_class
    @admin = create :user, :id => 1
  end

  it "should send a message and make user pending when email address not exists" do
    User.notify_observers :address_not_exists, user
    #described_class.instance.address_not_exists(user)
    expect(user.inbox_messages).to_not be_empty
    expect(user.state).to eq('pending')
  end

  it "should send a message and set user preferrences to not to receive email" do
    User.notify_observers :mail_rejected, user
    #described_class.instance.mail_rejected user
    expect(user.inbox_messages).not_to be_empty
    expect(user.preferred_want_receive_notification_email).to be_false
  end
end
