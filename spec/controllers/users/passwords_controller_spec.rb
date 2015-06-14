require 'rails_helper'

describe Users::PasswordsController do
  let(:old_password) { Forgery(:basic).password }
  let(:user){ create :user, state: 'active', password: old_password, password_confirmation: old_password }
  let(:new_password) { Forgery(:basic).password }
  context 'user not logged in' do
    describe "GET 'edit'" do
      it "redirects" do
        get :edit
        expect(response.status).to eq 302
      end
    end

    describe "PUT 'update'" do
      it "returns http success" do
        put 'update', :old_password => old_password, :password => new_password, :password_confirmation => new_password
        expect(response.status).to eq 302
      end
    end
  end

  context 'user logged in' do
    before do
      login_user user
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        expect(response).to be_success
      end
    end

    describe "PUT 'update'" do
      it "returns http success" do
        put 'update', :old_password => old_password, :password => new_password, :password_confirmation => new_password
        expect(response).to redirect_to(user)

        user.reload

        expect(user.valid_password?(new_password)).to be true
      end

      it "render error" do
        put 'update', :old_password => 'wrongpass', :password => new_password, :password_confirmation => new_password
        expect(response).to render_template('edit')
        user.reload
        expect(user.valid_password?(old_password)).to be true
        expect(user.valid_password?(new_password)).to be false
      end
    end
  end
end
