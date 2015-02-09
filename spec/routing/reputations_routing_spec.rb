# coding: utf-8
require "spec_helper"

describe ReputationsController do
  describe "routing" do

    it "routes to #index" do
      get("/reputations").should route_to("reputations#index")
    end

    it "routes to #new" do
      get("/reputations/new").should route_to("reputations#new")
    end

    it "routes to #show" do
      get("/reputations/1").should route_to("reputations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/reputations/1/edit").should route_to("reputations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/reputations").should route_to("reputations#create")
    end

    it "routes to #update" do
      put("/reputations/1").should route_to("reputations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/reputations/1").should route_to("reputations#destroy", :id => "1")
    end

  end
end
