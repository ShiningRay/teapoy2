require "spec_helper"

describe ChangeLogsController do
  describe "routing" do

    it "routes to #index" do
      get("/change_logs").should route_to("change_logs#index")
    end

    it "routes to #new" do
      get("/change_logs/new").should route_to("change_logs#new")
    end

    it "routes to #show" do
      get("/change_logs/1").should route_to("change_logs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/change_logs/1/edit").should route_to("change_logs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/change_logs").should route_to("change_logs#create")
    end

    it "routes to #update" do
      put("/change_logs/1").should route_to("change_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/change_logs/1").should route_to("change_logs#destroy", :id => "1")
    end

  end
end
