require 'spec_helper'

describe Users::DislikesController do
  let!(:user) { create :user }
  let!(:target) { create :user }
  before do
    controller.request.env["HTTP_REFERER"] = 'http://test.localdomin/'
  end
  context "when the user not logged in, " do
    describe '#create' do
      it "should return forbidden" do
        get :index, :user_id => user.id
        expect(response.status).to eq(403)
      end
    end
    describe '#destroy' do
      it "should return forbidden" do
        delete :destroy, :user_id => user.id, :id => target.id
        expect(response.status).to eq(403)
      end
    end
  end
  context "when the user logged in" do
    before do
      session[:user_id] = user.id
      controller.stub(:current_user){user}
    end

    context "when the user dislike the target user" do
      before :each do
        user.dislike! target
      end
      describe '#index' do
        it "should return the users disliked" do
          get :index, :user_id => user.id
          expect(assigns(:dislikes)).to match_array([target])
        end
      end
      describe '#create' do
        it "should not change dislike state" do
          post :create, user_id: user.id, id: target.id
          expect(user.disliked?(target)).to be_true
        end
      end
      describe '#destroy' do
        it "should remove dislike" do
          delete :destroy, :user_id => user.id, :id => target.id
          user.disliked?(target).should be_false
        end
      end
    end

    context "when the user haven't disliked the target user" do
      describe '#index' do
        it "should return no disliked" do
          get :index, :user_id => user.id
          assigns(:dislikes).should be_empty
        end
      end

      describe '#create' do
        it "should set dislike" do
          post :create, :user_id => user.id, :id => target.id
          user.disliked?(target).should be_true
        end
      end
      describe '#destroy' do
        it "should not dislike" do
          delete :destroy, :user_id => user.id, :id => target.id
          user.disliked?(target).should be_false
        end
      end
    end
  end
end
