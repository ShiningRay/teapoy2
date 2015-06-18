require 'rails_helper'

RSpec.feature "Registrations", type: :feature do
  scenario "Guest sign up new account" do
    visit new_user_path
    fill_in "user_name", with: 'ShiningRay'
    fill_in "user_login", with: 'ShiningRay'
    fill_in "user_email", with: 'shiningray@bling0.com'
    fill_in "user_password", with: '1234qwer'
    fill_in "user_password_confirmation", with: '1234qwer'
    click_button '注册'

    expect(page).to have_selector(:xpath, "//a[@href='/']")
    # 10s 后跳转首页
    # sleep 11
    # expect(current_path).to eq('/')
  end
end
