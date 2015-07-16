# == Schema Information
#
# Table name: user_profiles
#
#  id                              :integer          not null, primary key
#  user_id                         :integer          not null
#  sex                             :string(255)      default("")
#  birthday                        :date
#  hometown                        :string(255)
#  bio                             :string(255)
#  want_receive_notification_email :boolean          default(TRUE), not null
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id) UNIQUE
#

class UserProfile < ActiveRecord::Base
  belongs_to :user, inverse_of: :profile
  validates :user, presence: true
  # field :sex, type: String, default: ''
  # field :birthday, type: Date
  # field :hometown, type: String
  # field :bio, type: String
  # field :want_receive_notification_email, type: Boolean, default: true
end
