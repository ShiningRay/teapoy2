# coding: utf-8
require "spec_helper"

describe ReputationLogsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/reputation_logs")).to route_to("reputation_logs#index")
    end

    it "routes to #new" do
      expect(get("/reputation_logs/new")).to route_to("reputation_logs#new")
    end

    it "routes to #show" do
      expect(get("/reputation_logs/1")).to route_to("reputation_logs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/reputation_logs/1/edit")).to route_to("reputation_logs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/reputation_logs")).to route_to("reputation_logs#create")
    end

    it "routes to #update" do
      expect(put("/reputation_logs/1")).to route_to("reputation_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/reputation_logs/1")).to route_to("reputation_logs#destroy", :id => "1")
    end

  end
end
