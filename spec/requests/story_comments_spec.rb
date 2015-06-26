require 'rails_helper'

RSpec.describe "StoryComments", type: :request do
  describe "GET /story_comments" do
    it "works! (now write some real specs)" do
      get story_comments_path
      expect(response).to have_http_status(200)
    end
  end
end
