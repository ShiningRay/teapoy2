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

require 'rails_helper'

RSpec.describe PersistenceToken, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
