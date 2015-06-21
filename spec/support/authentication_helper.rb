# spec/support/authentication_helper.rb
module AuthenticationHelper
  def sign_in(user = FactoryGirl.create(:user))
    visit new_session_path

    fill_in 'user_session_login',    with: user.email
    fill_in 'user_session_password', with: user.password
    click_button "登录"

    return user
  end

  def login_user(user=create(:active_user))
    @current_user = user
    session[:user_credentials] = user.persistence_token
    session[:user_credentials_id] = user.id
    @current_user
  end

  def current_user
    @current_user
  end
end
