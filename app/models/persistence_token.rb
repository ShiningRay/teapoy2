class PersistenceToken < ActiveRecord::Base
  belongs_to :user
  validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true
end
