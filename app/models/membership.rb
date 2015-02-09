# coding: utf-8
class Membership < ActiveRecord::Base
  include Tenacity
  belongs_to :user
  t_belongs_to :group

  validates :user_id, uniqueness: {scope: :group_id}
end
