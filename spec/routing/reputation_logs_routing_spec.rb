# coding: utf-8
require "spec_helper"

describe ReputationLogsController do
  describe "routing" do

    it "routes to #index" do
      get("/reputation_logs").should route_to("reputation_logs#index")
    end

    it "routes to #new" do
      get("/reputation_logs/new").should route_to("reputation_logs#new")
    end

    it "routes to #show" do
      get("/reputation_logs/1").should route_to("reputation_logs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/reputation_logs/1/edit").should route_to("reputation_logs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/reputation_logs").should route_to("reputation_logs#create")
    end

    it "routes to #update" do
      put("/reputation_logs/1").should route_to("reputation_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/reputation_logs/1").should route_to("reputation_logs#destroy", :id => "1")
    end

  end
end
