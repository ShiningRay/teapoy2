# coding: utf-8
class Balance < ActiveRecord::Base
  class InsufficientFunds < StandardError; end
  belongs_to :user
  has_many :transactions
  validates :credit, :numericality => {:greater_than_or_equal_to => 0}
end
