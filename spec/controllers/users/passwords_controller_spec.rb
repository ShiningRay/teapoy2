require 'rails_helper'

describe Users::PasswordsController do
  context 'user not logged in' do
    describe "GET 'edit'" do
      it "redirects" do
        get 'edit'
        expect(response.status).to eq 302
      end
    end

    describe "PUT 'update'" do
      it "returns http success" do
        put 'update', :old_password => '1234qwer', :password => '1234qwer', :password_confirmation => '1234qwer'
        expect(response.status).to eq 302
      end
    end
  end
  context 'user logged in' do

    before do
      @user = create(:user, state: 'active')
      controller.stub(:current_user) { @user }
      #post session_path, user_session: {login: 'test', password: '1234qwer'}
    end
    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        response.should be_success
      end
    end

    describe "PUT 'update'" do
      it "returns http success" do
        put 'update', :old_password => '1234qwer', :password => '12345678', :password_confirmation => '12345678'
        response.should redirect_to(@user)
        @user.reload
        expect(@user.valid_password?('12345678')).to be_true
      end
      it "render error" do
        put 'update', :old_password => 'wrongpass', :password => '12345678', :password_confirmation => '12345678'
        response.should render_template('edit')
        @user.reload
        expect(@user.valid_password?('1234qwer')).to be_true
        expect(@user.valid_password?('12345678')).to be_false
      end
    end
  end
end
