# spec/support/authentication_helper.rb
module AuthenticationHelper
  def sign_in
    visit root_path

    user = FactoryGirl.create(:user)

    fill_in 'user_session_email',    with: user.email
    fill_in 'user_session_password', with: user.password
    click_button "Sign in"

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
