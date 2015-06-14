# coding: utf-8
# == Schema Information
#
# Table name: reputations
#
#  id       :integer          not null, primary key
#  user_id  :integer
#  group_id :integer
#  value    :integer          default(0)
#  state    :string(255)      default("neutral")
#  hide     :boolean          default(FALSE)
#

require 'rails_helper'

describe Reputation do
  pending "add some examples to (or delete) #{__FILE__}"
end
