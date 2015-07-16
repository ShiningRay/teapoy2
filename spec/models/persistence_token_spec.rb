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

require 'rails_helper'

RSpec.describe PersistenceToken, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
