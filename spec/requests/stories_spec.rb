require 'rails_helper'

RSpec.describe "Stories", type: :request do
  let!(:guestbook) { create :guestbook }
  describe "GET /guestbooks/1/stories" do
    it "returns ok" do
      get guestbook_stories_path(guestbook)
      expect(response).to have_http_status(200)
    end
  end
end
