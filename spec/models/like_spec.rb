# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  story_id   :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_likes_on_story_id_and_user_id  (story_id,user_id) UNIQUE
#

require 'rails_helper'

RSpec.describe Like, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
