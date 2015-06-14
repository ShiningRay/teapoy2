# coding: utf-8

require 'rails_helper'

describe Notification do
  before(:each) do

  end
  let(:target_user){ create(:user)  }
  let(:source_article) { create(:article) }

  it "should successfully send a notification" do
    n = Notification.send_to(target_user, "Noop", source_article)
  end
end
