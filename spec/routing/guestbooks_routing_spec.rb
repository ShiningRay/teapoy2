require "rails_helper"

RSpec.describe GuestbooksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/guestbooks").to route_to("guestbooks#index")
    end

    it "routes to #new" do
      expect(:get => "/guestbooks/new").to route_to("guestbooks#new")
    end

    it "routes to #show" do
      expect(:get => "/guestbooks/1").to route_to("guestbooks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/guestbooks/1/edit").to route_to("guestbooks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/guestbooks").to route_to("guestbooks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/guestbooks/1").to route_to("guestbooks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/guestbooks/1").to route_to("guestbooks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/guestbooks/1").to route_to("guestbooks#destroy", :id => "1")
    end

  end
end
