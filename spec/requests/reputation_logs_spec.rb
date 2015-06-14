# coding: utf-8
require 'rails_helper'

describe "ReputationLogs" do
  describe "GET /reputation_logs" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get reputation_logs_path
      response.status.should be(200)
    end
  end
end
