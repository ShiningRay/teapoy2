# == Schema Information
#
# Table name: story_comments
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  author_id  :integer          not null
#  content    :text(65535)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_story_comments_on_story_id_and_author_id  (story_id,author_id)
#

class StoryComment < ActiveRecord::Base
  belongs_to :story, touch: true
  belongs_to :author, class_name: 'User'
  validates :story, :author, :content, presence: true

end
