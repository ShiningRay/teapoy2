require 'rails_helper'

RSpec.describe Story, type: :model do
  describe '.latest' do
    before {
      Story.delete_all
    }
    it 'orders from new to old' do
      # guestbook = create :guestbook
      @stories = create_list :story, 4
      expect(Story.latest.all).to match(@stories.reverse)
    end
  end
end
