# coding: utf-8
# == Schema Information
#
# Table name: references
#
#  id            :integer          not null, primary key
#  source_id     :integer
#  target_id     :integer
#  relation_type :string(255)
#  detected      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe Reference do
  pending "add some examples to (or delete) #{__FILE__}"
end
