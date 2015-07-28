# coding: utf-8
require 'rails_helper'

describe TopicsController, :type => :controller do
  let(:author){create :user}
  let(:group){create :group, :alias => 'pool'}

  describe 'GET index' do
    context 'there is a published topic: ' do
      let(:topic) {
        create :topic, group: group, user: author, status: 'publish'
      }
      it 'shows speicific topic' do
        get :show, :group_id => group.alias, :id => topic.id
        expect(response).to be_success
        expect(assigns(:topic)).to eq(topic)
      end
    end

    # context 'there is a private topic:' do
    #   let(:topic) { create :topic, group: group, user: author, status: 'private' }

    #   context 'the viewing user is author' do
    #     before :each do
    #       login_user author
    #     end
    #     it 'shows this topic' do
    #       get :show, {group_id: group.alias, id: topic.id}
    #       expect(response).to be_success
    #     end
    #   end

    #   it 'does not show this topic' do

    #   end
    # end

    context 'no corresponding topic' do
      it 'shows 404 page' do
        get :show, {group_id: group.alias, id: 404}
        expect(response.status).to eq(404)
      end
    end

    context 'no corresponding group' do
      it 'shows 404 page' do
        get :show, {group_id: 'notexists', id: 404}
        expect(response.status).to eq(404)
      end

      it 'shows 404 page even id exists' do
        topic = create :topic
        get :show, {group_id: 'notexists', id: topic.id}
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST create' do
    context 'when user logged in and is active' do
      before { login_user }
      it 'creates topic(old picture upload)' do
        title = Forgery::LoremIpsum.title
        content = Forgery::LoremIpsum.paragraph

        expect{
          post :create, topic: {
            title: title,
            content: content,
            picture: fixture_file_upload('2345.jpg', 'image/jpeg')
          }, group_id: group.alias
        }.to change(Topic, :count)

        expect(assigns(:topic)).to be_valid
        expect(assigns(:topic).top_post).to be_valid
        expect(assigns(:topic).top_post.topic_id).to eq(assigns(:topic).id)
        expect(assigns(:topic).top_post.attachments).not_to be_blank
      end
    end
  end

  describe 'POST subscribe' do
    before {login_user}
    let(:topic) { create :topic }
    it 'creates subscription' do
      expect {
        post :subscribe, id: topic.id, group_id: topic.group_id
      }.to change(Subscription, :count)
    end
  end

  describe 'POST unsubscribe' do
    before {login_user}
    let(:topic) { create :topic }
    it 'creates subscription' do
      current_user.subscribe topic
      expect {
        post :unsubscribe, id: topic.id, group_id: topic.group_id
      }.to change(Subscription, :count).by(-1)
    end
  end
end
