require 'rails_helper'

RSpec.describe "Guestbooks", type: :request do
  describe "GET /guestbooks" do
    it "works! (now write some real specs)" do
      get guestbooks_path
      expect(response).to have_http_status(200)
    end
  end
end
