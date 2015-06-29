require 'rails_helper'

RSpec.describe "StoryComments", type: :request do
  let!(:guestbook) { create :guestbook }
  let!(:story) { create :story, guestbook: guestbook }
  describe "GET /guestbooks/1/stories/1/comments.json" do
    it "returns 200" do
      get guestbook_story_story_comments_path(guestbook, story, format: :json)
      expect(response).to have_http_status(200)
    end
  end
end
