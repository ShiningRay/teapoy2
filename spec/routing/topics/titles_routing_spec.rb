require "rails_helper"

RSpec.describe Topics::TitlesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/topics/titles").to route_to("topics/titles#index")
    end

    it "routes to #new" do
      expect(:get => "/topics/titles/new").to route_to("topics/titles#new")
    end

    it "routes to #show" do
      expect(:get => "/topics/titles/1").to route_to("topics/titles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/topics/titles/1/edit").to route_to("topics/titles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/topics/titles").to route_to("topics/titles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/topics/titles/1").to route_to("topics/titles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/topics/titles/1").to route_to("topics/titles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/topics/titles/1").to route_to("topics/titles#destroy", :id => "1")
    end

  end
end
