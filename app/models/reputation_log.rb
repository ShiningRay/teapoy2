# coding: utf-8
class ReputationLog < ActiveRecord::Base
  include Tenacity
  belongs_to :user
  belongs_to :group
  t_belongs_to :post


end
