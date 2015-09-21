require 'rails_helper'

RSpec.describe "Topics::Titles", type: :request do
  describe "GET /topics_titles" do
    it "works! (now write some real specs)" do
      get topics_titles_path
      expect(response).to have_http_status(200)
    end
  end
end
