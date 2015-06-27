require "rails_helper"

RSpec.describe StoryCommentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/guestbooks/1/stories/1/comments").to route_to("story_comments#index", guestbook_id: '1', story_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/guestbooks/1/stories/1/comments").to route_to("story_comments#create", guestbook_id: '1', story_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/guestbooks/1/stories/1/comments/1").to route_to("story_comments#destroy", :id => "1", guestbook_id: '1', story_id: '1')
    end

  end
end
