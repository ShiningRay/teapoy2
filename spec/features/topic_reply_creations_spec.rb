require 'rails_helper'

RSpec.feature 'TopicReplyCreations', js: true, type: :feature do
  let(:user){ create :active_user }
  let(:group) { create :group, alias: 'pool'}
  let(:topic) { create :topic, group: group }
  before {
    sign_in user
  }
  scenario 'user replies to topic' do
    visit group_topic_path(group.alias, topic)
    post_content = 'It is a reply'
    # fill_in 'post_content', with: post_content
    find(:css,  '.simditor-body').set(post_content)
    # attach_file 'post_picture', Rails.root.join('spec/fixtures/2345.jpg')
    click_button '回复'

    sleep 2 # wait for ajax to finish

    post = topic.posts.last

    expect(post.user).to eq(user)
    # expect(post).to be_picture
    expect(post.content).to eq(post_content)
    expect(page).to have_content(user.name)
    expect(find("\#post_#{post.id}")).to have_content(post_content)

    # 10s 后跳转首页
    # sleep 11
    # expect(current_path).to eq('/')
  end
end
