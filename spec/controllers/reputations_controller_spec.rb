# coding: utf-8
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

describe ReputationsController do

  # This should return the minimal set of attributes required to create a valid
  # Reputation. As you add validations to Reputation, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all reputations as @reputations" do
      reputation = Reputation.create! valid_attributes
      get :index
      assigns(:reputations).should eq([reputation])
    end
  end

  describe "GET show" do
    it "assigns the requested reputation as @reputation" do
      reputation = Reputation.create! valid_attributes
      get :show, :id => reputation.id
      assigns(:reputation).should eq(reputation)
    end
  end

  describe "GET new" do
    it "assigns a new reputation as @reputation" do
      get :new
      assigns(:reputation).should be_a_new(Reputation)
    end
  end

  describe "GET edit" do
    it "assigns the requested reputation as @reputation" do
      reputation = Reputation.create! valid_attributes
      get :edit, :id => reputation.id
      assigns(:reputation).should eq(reputation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Reputation" do
        expect {
          post :create, :reputation => valid_attributes
        }.to change(Reputation, :count).by(1)
      end

      it "assigns a newly created reputation as @reputation" do
        post :create, :reputation => valid_attributes
        assigns(:reputation).should be_a(Reputation)
        assigns(:reputation).should be_persisted
      end

      it "redirects to the created reputation" do
        post :create, :reputation => valid_attributes
        response.should redirect_to(Reputation.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reputation as @reputation" do
        # Trigger the behavior that occurs when invalid params are submitted
        Reputation.any_instance.stub(:save).and_return(false)
        post :create, :reputation => {}
        assigns(:reputation).should be_a_new(Reputation)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Reputation.any_instance.stub(:save).and_return(false)
        post :create, :reputation => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested reputation" do
        reputation = Reputation.create! valid_attributes
        # Assuming there are no other reputations in the database, this
        # specifies that the Reputation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Reputation.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => reputation.id, :reputation => {'these' => 'params'}
      end

      it "assigns the requested reputation as @reputation" do
        reputation = Reputation.create! valid_attributes
        put :update, :id => reputation.id, :reputation => valid_attributes
        assigns(:reputation).should eq(reputation)
      end

      it "redirects to the reputation" do
        reputation = Reputation.create! valid_attributes
        put :update, :id => reputation.id, :reputation => valid_attributes
        response.should redirect_to(reputation)
      end
    end

    describe "with invalid params" do
      it "assigns the reputation as @reputation" do
        reputation = Reputation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Reputation.any_instance.stub(:save).and_return(false)
        put :update, :id => reputation.id, :reputation => {}
        assigns(:reputation).should eq(reputation)
      end

      it "re-renders the 'edit' template" do
        reputation = Reputation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Reputation.any_instance.stub(:save).and_return(false)
        put :update, :id => reputation.id, :reputation => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested reputation" do
      reputation = Reputation.create! valid_attributes
      expect {
        delete :destroy, :id => reputation.id
      }.to change(Reputation, :count).by(-1)
    end

    it "redirects to the reputations list" do
      reputation = Reputation.create! valid_attributes
      delete :destroy, :id => reputation.id
      response.should redirect_to(reputations_url)
    end
  end

end
