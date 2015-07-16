# == Schema Information
#
# Table name: persistence_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string(255)
#  agent      :string(255)
#  ip         :decimal(12, )    default(0), not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_persistence_tokens_on_token       (token) UNIQUE
#  index_persistence_tokens_on_updated_at  (updated_at)
#  index_persistence_tokens_on_user_id     (user_id)
#

class PersistenceToken < ActiveRecord::Base
  belongs_to :user
  validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true
end
