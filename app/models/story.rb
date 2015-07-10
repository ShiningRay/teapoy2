class Story < ActiveRecord::Base
  belongs_to :guestbook
  belongs_to :author, class_name: 'User'
  has_many :comments, class_name: 'StoryComment', dependent: :delete_all
  has_many :likes, dependent: :delete_all
  has_many :likers, through: :likes, source: :user
  validates :guestbook, :content, presence: true
  validates :author, presence: true, if: -> { author_id? }
  # validates :email, presence: true, unless: -> { author_id? }

  scope :latest, -> { order(:id => :desc )}
  scope :anonymous, -> { where(anonymous: true) }
  scope :signed, -> { where(anonymous: false) }
  before_validation {
    self.anonymous = true unless author_id?
  }
  mount_uploader :picture, PictureUploader
end
