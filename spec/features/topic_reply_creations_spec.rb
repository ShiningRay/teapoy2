require 'rails_helper'

RSpec.feature 'TopicReplyCreations', js: true, type: :feature do
  let(:user){ create :active_user }
  let(:group) { create :group, alias: 'pool'}
  let(:topic) { create :topic, group: group }
  before {
    page.driver.allow_url("ajax.aspnetcdn.com")
    page.driver.allow_url("libs.baidu.com")
    page.driver.allow_url("log.hm.baidu.com")
    page.driver.allow_url("hm.baidu.com")
    sign_in user
  }
  scenario 'user replies to topic' do
    visit group_topic_path(group.alias, topic)
    post_content = 'It is a reply'
    # fill_in 'post_content', with: post_content
    find(:css,  '.simditor-body').set(post_content)
    # attach_file 'post_picture', Rails.root.join('spec/fixtures/2345.jpg')

    click_button '回复'
    # save_and_open_screenshot
    expect(page).to have_content(user.name)
    post = Post.last
    expect(page).to have_css("\#post_#{post.id}", text: post_content)
    expect(post.user).to eq(user)
    # expect(post).to be_picture
    expect(post.content).to eq(post_content)

    # 10s 后跳转首页
    # sleep 11
    # expect(current_path).to eq('/')
  end
end
