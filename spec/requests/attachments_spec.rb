# coding: utf-8
require 'rails_helper'

describe "Attachments" do
  describe "GET /attachments" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get attachments_path
      response.status.should be(200)
    end
  end
end
