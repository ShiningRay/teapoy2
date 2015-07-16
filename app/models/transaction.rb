# coding: utf-8
# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  balance_id :integer          not null
#  amount     :integer          default(0), not null
#  reason     :string(255)
#  created_at :datetime
#  deal_type  :string(255)
#  deal_id    :integer
#
# Indexes
#
#  index_transactions_on_balance_id_and_created_at  (balance_id,created_at)
#  index_transactions_on_deal_type_and_deal_id      (deal_type,deal_id)
#

class Transaction < ActiveRecord::Base
  belongs_to :balance

  def new_transaction(amount , reason)
    self.amount=amount
    self.reason=reason
    self.save!
  end
end
