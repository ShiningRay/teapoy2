# coding: utf-8
require "spec_helper"

describe ReferencesController do
  describe "routing" do

    it "routes to #index" do
      get("/references").should route_to("references#index")
    end

    it "routes to #new" do
      get("/references/new").should route_to("references#new")
    end

    it "routes to #show" do
      get("/references/1").should route_to("references#show", :id => "1")
    end

    it "routes to #edit" do
      get("/references/1/edit").should route_to("references#edit", :id => "1")
    end

    it "routes to #create" do
      post("/references").should route_to("references#create")
    end

    it "routes to #update" do
      put("/references/1").should route_to("references#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/references/1").should route_to("references#destroy", :id => "1")
    end

  end
end
