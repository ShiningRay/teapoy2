require "spec_helper"

describe ReadStatusesController do
  describe "routing" do

    it "routes to #index" do
      get("/read_statuses").should route_to("read_statuses#index")
    end

    it "routes to #new" do
      get("/read_statuses/new").should route_to("read_statuses#new")
    end

    it "routes to #show" do
      get("/read_statuses/1").should route_to("read_statuses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/read_statuses/1/edit").should route_to("read_statuses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/read_statuses").should route_to("read_statuses#create")
    end

    it "routes to #update" do
      put("/read_statuses/1").should route_to("read_statuses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/read_statuses/1").should route_to("read_statuses#destroy", :id => "1")
    end

  end
end
