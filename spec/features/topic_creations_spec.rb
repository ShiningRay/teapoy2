require 'rails_helper'

RSpec.feature "TopicCreations", type: :feature do
  let(:user){ create :active_user }
  let(:group) { create :group, alias: 'pool'}
  before { sign_in user }
  scenario "user adds new topic" do
    visit new_group_article_path(group.alias)

    fill_in "article_title", with: 'test'
    fill_in "article_content", with: 'ShiningRay'
    attach_file "article_picture", Rails.root.join('spec/fixtures/2345.jpg')

    click_button '发布'


    expect(page).to have_content('test')
    expect(page).to have_content('ShiningRay')
    # 10s 后跳转首页
    # sleep 11
    # expect(current_path).to eq('/')
  end
end
