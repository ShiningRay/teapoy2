# coding: utf-8
# == Schema Information
#
# Table name: reputation_logs
#
#  id            :integer          not null, primary key
#  reputation_id :integer
#  user_id       :integer
#  group_id      :integer
#  post_id       :string(24)       default("0"), not null
#  amount        :integer
#  reason        :string(255)
#  created_on    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe ReputationLog do
  pending "add some examples to (or delete) #{__FILE__}"
end
