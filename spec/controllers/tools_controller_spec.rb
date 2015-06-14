# coding: utf-8
require 'rails_helper'

describe ToolsController do

  describe "GET 'query_name_logs'" do
    before { login_user }
    it "returns http success" do
      get 'query_name_logs'
      expect(response).to be_success
    end
  end

end
