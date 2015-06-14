require "spec_helper"

describe ChangeLogsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/change_logs")).to route_to("change_logs#index")
    end

    it "routes to #new" do
      expect(get("/change_logs/new")).to route_to("change_logs#new")
    end

    it "routes to #show" do
      expect(get("/change_logs/1")).to route_to("change_logs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/change_logs/1/edit")).to route_to("change_logs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/change_logs")).to route_to("change_logs#create")
    end

    it "routes to #update" do
      expect(put("/change_logs/1")).to route_to("change_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/change_logs/1")).to route_to("change_logs#destroy", :id => "1")
    end

  end
end
