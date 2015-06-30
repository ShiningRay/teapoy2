# coding: utf-8

require 'rails_helper'

describe Notification do
  before(:each) do

  end
  let(:target_user){ create(:user)  }
  let(:source_topic) { create(:topic) }

  it "should successfully send a notification" do
    mail = double("Mail", deliver: '')
    allow(UserNotifier).to receive(:notify).and_return(mail)
    # allow_any_instance_of(UserNotifier).to receive(:deliver).and_return(nil)
    expect { Notification.send_to(target_user, "Noop", source_topic) }.to change { target_user.notifications.count }.by(1)
    # expect(UserNotifier).to have_received(:notify)
  end
end
