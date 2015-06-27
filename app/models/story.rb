class Story < ActiveRecord::Base
  belongs_to :guestbook
  belongs_to :author, class_name: 'User'
  has_many :comments, class_name: 'StoryComment'
  validates :guestbook, :author, :content, presence: true
end
