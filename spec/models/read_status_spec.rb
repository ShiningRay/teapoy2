# == Schema Information
#
# Table name: read_statuses
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  group_id   :integer
#  article_id :integer          not null
#  read_to    :integer          default(0)
#  read_at    :datetime
#  updates    :integer          default(0)
#

require 'rails_helper'

describe ReadStatus do
  pending "add some examples to (or delete) #{__FILE__}"
end
