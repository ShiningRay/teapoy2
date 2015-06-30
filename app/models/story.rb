class Story < ActiveRecord::Base
  belongs_to :guestbook
  belongs_to :author, class_name: 'User'
  has_many :comments, class_name: 'StoryComment'
  has_many :likes
  has_many :likers, through: :likes, source: :user
  validates :guestbook, :author, :content, presence: true

  scope :latest, -> { order(:id => :desc )}
  scope :anonymous, -> { where(anonymous: true) }
  scope :signed, -> { where(anonymous: false) }

  mount_uploader :picture, PictureUploader
end
