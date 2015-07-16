# coding: utf-8
# == Schema Information
#
# Table name: balances
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  charm      :integer          default(0), not null
#  credit     :integer          default(0), not null
#  level      :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_balances_on_user_id  (user_id) UNIQUE
#

class Balance < ActiveRecord::Base
  class InsufficientFunds < StandardError; end
  belongs_to :user
  has_many :transactions
  validates :credit, :numericality => {:greater_than_or_equal_to => 0}
end
