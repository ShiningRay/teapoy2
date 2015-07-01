# coding: utf-8
require 'rails_helper'

describe TopicsController, :type => :controller do
  let(:author){create :user}
  let(:group){create :group, :alias => 'pool'}

  describe 'GET index' do
    context 'there is a published topic: ' do
      let(:topic){create :topic, group: group, user: author, slug: 'test', status: 'publish'}
      it 'should show speicific topic' do
        get :show, :group_id => group.alias, :id => topic.id
        expect(response).to be_success
        expect(assigns(:topic)).to eq(topic)
      end
    end

    context 'there is a private topic:' do
      let(:topic) { create :topic, group: group, user: author, status: 'private' }

      context 'the viewing user is author' do
        before :each do
          login_user author
        end
        it 'shows this topic' do
          get :show, {group_id: group.alias, id: topic.id}
          expect(response).to be_success
        end
      end

      it 'does not show this topic' do

      end
    end
  end

  describe 'POST create' do
    context 'when user logged in and is active' do
      before { login_user }
      it 'creates topic' do
        title = Forgery::LoremIpsum.title
        content = Forgery::LoremIpsum.paragraph

        expect{
          post :create, topic: {title: title, content: content}, group_id: group.alias
        }.to change(Topic, :count)

        expect(assigns(:topic)).to be_valid
        expect(assigns(:topic).top_post).to be_valid
        expect(assigns(:topic).top_post.topic_id).to eq(assigns(:topic).id)
        expect(assigns(:topic).posts_count).to eq(1)
      end
    end
  end
end
