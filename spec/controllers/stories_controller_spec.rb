require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe StoriesController, type: :controller do
  let(:story) { create :story }
  let(:guestbook) { story.guestbook }
  let(:author) { story.author }

  describe 'GET #index' do
    before {
      @guestbook = create :guestbook
      @stories = create_list :story, 3, guestbook: @guestbook
      get :index, guestbook_id: @guestbook.id
    }
    subject { assigns(:stories) }
    it { should match(@stories.reverse) }
  end

  describe 'POST #create' do
    context 'when user logged in' do
      before {
        login_user
      }
      it 'creates story' do
        expect {
          post :create, story: {
            content: 'testtest'
          }, guestbook_id: guestbook.id
        }.to change{ guestbook.stories.count }
      end
      it 'uploads picture' do
        file =  fixture_file_upload('2345.jpg', "image/jpeg")
        post :create, story: {
          content: 'testtest',
          picture: file
        }, guestbook_id: guestbook.id
        expect(assigns(:story)).to be_picture
      end
      it 'creates anonymous story' do
        post :create, story: {
            content: 'testtest',
            anonymous: '1'
          }, guestbook_id: guestbook.id
        expect(assigns(:story)).to be_anonymous
      end
    end

    context 'when not logged in' do
      it 'creates anonymous story' do
        post :create, story: {
          content: 'testtest',
          email: 'test@test.com'
        }, guestbook_id: guestbook.id
        expect(assigns(:story)).to be_anonymous
      end
      context 'and given email is registered' do
        before { @user = create :active_user, email: 'test@test.com' }

        it 'requires login' do
          post :create, story: {
            content: 'testtest',
            email: 'test@test.com'
          }, guestbook_id: guestbook.id
          expect(response).to be_redirect
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when author logged in' do
      before {
        login_user
        @story = create :story, author: current_user
        @guestbook = @story.guestbook
      }

      it 'deletes the story' do
        expect {
          delete :destroy, id: @story.id, guestbook_id: @story.guestbook_id
        }.to change{ @guestbook.stories.count }.by(-1)
      end
    end
  end

  describe 'POST #like' do
    context 'user logged in' do
      before {
        login_user
        @story = create :story
        @guestbook = @story.guestbook
      }

      it 'add like for the story' do
        expect {
          post :like, id: @story.id, guestbook_id: @guestbook.id
        }.to change { @story.likes.count }
      end
    end
  end

  describe 'POST #unlike' do
    context 'user logged in' do
      before {
        login_user
        @story = create :story
        @guestbook = @story.guestbook
        create :like, user: current_user, story: @story
      }

      it 'removes like for the story' do
        expect {
          post :unlike, id: @story.id, guestbook_id: @guestbook.id
        }.to change { @story.likes.count }.by(-1)
      end
    end
  end
end
