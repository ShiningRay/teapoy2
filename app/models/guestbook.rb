class Guestbook < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  validates :name, :owner, presence: true
  validates :name, uniqueness: true
end
