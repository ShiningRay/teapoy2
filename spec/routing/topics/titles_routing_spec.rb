require "rails_helper"

RSpec.describe Topics::TitlesController, type: :routing do
  describe "routing" do


    it "routes to #update via PUT" do
      expect(:put => "/groups/1/topics/2/titles").to route_to("topics/titles#update", group_id: "1", topic_id: '2')
    end

    it "routes to #update via PATCH" do
      expect(:put => "/groups/1/topics/2/titles").to route_to("topics/titles#update", group_id: "1", topic_id: '2')
    end


  end
end
