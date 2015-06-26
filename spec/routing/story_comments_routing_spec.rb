require "rails_helper"

RSpec.describe StoryCommentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/story_comments").to route_to("story_comments#index")
    end

    it "routes to #new" do
      expect(:get => "/story_comments/new").to route_to("story_comments#new")
    end

    it "routes to #show" do
      expect(:get => "/story_comments/1").to route_to("story_comments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/story_comments/1/edit").to route_to("story_comments#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/story_comments").to route_to("story_comments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/story_comments/1").to route_to("story_comments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/story_comments/1").to route_to("story_comments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/story_comments/1").to route_to("story_comments#destroy", :id => "1")
    end

  end
end
