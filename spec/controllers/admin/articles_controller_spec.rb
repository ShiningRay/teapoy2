# coding: utf-8
require 'rails_helper'

describe Admin::ArticlesController do

  #Delete this example and add some real ones
  it "should use Admin::ArticlesController" do
    controller.should be_an_instance_of(Admin::ArticlesController)
  end

  describe '#index' do
	  context "given a published article" do
	  	let!(:group){ create :group }
	  	let!(:article){ create :article, status: 'publish', group: group }

	  	it 'show article' do
	  		get :index, by_status: 'publish', group_id: group.id
	  		expect(response).to be_success
	  		expect(assigns(:articles)).to include(article)
	  		expect(response).to render_template("index")
	  	end
	  end
  end
end
