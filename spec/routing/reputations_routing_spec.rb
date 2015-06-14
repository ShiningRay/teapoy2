# coding: utf-8
require "spec_helper"

describe ReputationsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/reputations")).to route_to("reputations#index")
    end

    it "routes to #new" do
      expect(get("/reputations/new")).to route_to("reputations#new")
    end

    it "routes to #show" do
      expect(get("/reputations/1")).to route_to("reputations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/reputations/1/edit")).to route_to("reputations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/reputations")).to route_to("reputations#create")
    end

    it "routes to #update" do
      expect(put("/reputations/1")).to route_to("reputations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/reputations/1")).to route_to("reputations#destroy", :id => "1")
    end

  end
end
