require "rails_helper"

RSpec.describe LikersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/guestbooks/1/stories/1/likers").to route_to("likers#index",guestbook_id:'1', story_id: '1')
    end

    it "routes to #create" do
      expect(:post => "/guestbooks/1/stories/1/likers").to route_to("likers#create",guestbook_id:'1', story_id: '1')
    end

    it "routes to #destroy" do
      expect(:delete => "/guestbooks/1/stories/1/likers/1").to route_to("likers#destroy", :id => "1",guestbook_id:'1', story_id: '1')
    end

  end
end
