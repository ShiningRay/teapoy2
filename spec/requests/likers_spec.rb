require 'rails_helper'

RSpec.describe "Likers", type: :request do
  let!(:guestbook) { create :guestbook }
  let!(:story) { create :story, guestbook: guestbook }

  describe "GET /guestbooks/1/stories/1/likers.json" do
    it "returns likers" do
      get guestbook_story_likers_path(guestbook, story, format: :json)
      expect(response).to have_http_status(200)
    end
  end
end
