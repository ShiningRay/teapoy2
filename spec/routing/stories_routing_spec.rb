require "rails_helper"

RSpec.describe StoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/guestbooks/1/stories").to route_to("stories#index", guestbook_id: '1')
    end

    it "routes to #new" do
      expect(:get => "/guestbooks/1/stories/new").to route_to("stories#new", guestbook_id: '1')
    end

    it "routes to #show" do
      expect(:get => "/guestbooks/1/stories/1").to route_to("stories#show", :id => "1", guestbook_id: '1')
    end

    it "routes to #edit" do
      expect(:get => "/guestbooks/1/stories/1/edit").to route_to("stories#edit", :id => "1", guestbook_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/guestbooks/1/stories").to route_to("stories#create", guestbook_id: '1')
    end

    it "routes to #update via PUT" do
      expect(:put => "/guestbooks/1/stories/1").to route_to("stories#update", :id => "1", guestbook_id: '1')
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/guestbooks/1/stories/1").to route_to("stories#update", :id => "1", guestbook_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/guestbooks/1/stories/1").to route_to("stories#destroy", :id => "1", guestbook_id: '1')
    end

  end
end
