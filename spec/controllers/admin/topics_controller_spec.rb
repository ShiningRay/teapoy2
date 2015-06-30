# coding: utf-8
require 'rails_helper'

describe Admin::TopicsController, :type => :controller do

  #Delete this example and add some real ones
  it "should use Admin::TopicsController" do
    expect(controller).to be_an_instance_of(Admin::TopicsController)
  end

  describe '#index' do
	  context "given a published topic" do
	  	let!(:group){ create :group }
	  	let!(:topic){ create :topic, status: 'publish', group: group }
      let!(:admin){ create :user, :admin}

	  	it 'show topic' do
	  		get :index, {by_status: 'publish', group_id: group.id}, {user_credentials: admin.persistence_token , user_credentials_id: admin.id}
	  		expect(response).to be_success
	  		expect(assigns(:topics)).to include(topic)
	  		expect(response).to render_template("index")
	  	end
	  end
  end
end
