class UserProfile < ActiveRecord::Base
  belongs_to :user, inverse_of: :profile
  validates :user, presence: true
  # field :sex, type: String, default: ''
  # field :birthday, type: Date
  # field :hometown, type: String
  # field :bio, type: String
  # field :want_receive_notification_email, type: Boolean, default: true
end
