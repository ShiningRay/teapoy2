require 'rails_helper'

RSpec.feature "SignIns", type: :feature do
  scenario 'User wants to log in' do
    user = create :user

    visit new_session_path
    fill_in 'user_session_login', with: user.login
    fill_in 'user_session_password', with: user.password
    click_button '登录'

    expect(current_path).to eq('/all')
  end
end
