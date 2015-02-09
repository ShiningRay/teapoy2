require "spec_helper"

describe RewardsController do
  describe "routing" do

    it "routes to #index" do
      get("/rewards").should route_to("rewards#index")
    end

    it "routes to #new" do
      get("/rewards/new").should route_to("rewards#new")
    end

    it "routes to #show" do
      get("/rewards/1").should route_to("rewards#show", :id => "1")
    end

    it "routes to #edit" do
      get("/rewards/1/edit").should route_to("rewards#edit", :id => "1")
    end

    it "routes to #create" do
      post("/rewards").should route_to("rewards#create")
    end

    it "routes to #update" do
      put("/rewards/1").should route_to("rewards#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/rewards/1").should route_to("rewards#destroy", :id => "1")
    end

  end
end
