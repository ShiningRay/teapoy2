# coding: utf-8
require 'rails_helper'

describe ToolsController do

  describe "GET 'query_name_logs'" do
    it "returns http success" do
      get 'query_name_logs'
      response.should be_success
    end
  end

end
