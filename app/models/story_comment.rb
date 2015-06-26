class StoryComment < ActiveRecord::Base
  belongs_to :story
  belongs_to :author, class_name: 'User'
  validates :story, :author, :content, presence: true

end
