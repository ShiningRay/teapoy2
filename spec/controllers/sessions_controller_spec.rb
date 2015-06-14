# coding: utf-8
require 'rails_helper'


describe SessionsController do
	it "should use SessionsController" do
	  expect(controller).to be_an_instance_of(described_class)
	end

	describe '#show' do
		before { get :show }
		context 'when user not logged in' do
			it {should redirect_to(root_path)}
		end
		context 'when user logged in' do
			let!(:user){create :user}
			before { controller.stub(:current_user).and_return(user) }
			it { should redirect_to('/')}
		end
	end

	describe '#create' do
		let!(:user){create :user}
		context 'user' do
			before { post :create, user_session: {login: user.login, password: '1234qwer'}}
			it '' do
				expect(response).to redirect_to('/all')
				expect(assigns(:current_user)).to eq(user)
			end
		end
	end

	describe '#destroy' do

	end
end
