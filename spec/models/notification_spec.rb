# coding: utf-8

require 'rails_helper'

describe Notification do
  before(:each) do

  end
  let(:target_user){ create(:user)  }
  let(:source_article) { create(:article) }

  it "should successfully send a notification" do

    expect { Notification.send_to(target_user, "Noop", source_article) }.to change { target_user.notifications.count }.by(1)
  end
end
