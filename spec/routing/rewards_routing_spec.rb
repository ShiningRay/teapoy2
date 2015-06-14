require "spec_helper"

describe RewardsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/rewards")).to route_to("rewards#index")
    end

    it "routes to #new" do
      expect(get("/rewards/new")).to route_to("rewards#new")
    end

    it "routes to #show" do
      expect(get("/rewards/1")).to route_to("rewards#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/rewards/1/edit")).to route_to("rewards#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/rewards")).to route_to("rewards#create")
    end

    it "routes to #update" do
      expect(put("/rewards/1")).to route_to("rewards#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/rewards/1")).to route_to("rewards#destroy", :id => "1")
    end

  end
end
