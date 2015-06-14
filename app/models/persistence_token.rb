# == Schema Information
#
# Table name: persistence_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string(255)
#  agent      :string(255)
#  ip         :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

class PersistenceToken < ActiveRecord::Base
  belongs_to :user
  validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true
end
