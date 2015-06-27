require 'rails_helper'

RSpec.describe "Likers", type: :request do
  describe "GET /likers" do
    it "works! (now write some real specs)" do
      get likers_path
      expect(response).to have_http_status(200)
    end
  end
end
