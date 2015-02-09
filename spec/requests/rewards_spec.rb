require 'spec_helper'

describe "Rewards" do
  describe "GET /rewards" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get rewards_path
      response.status.should be(200)
    end
  end
end
