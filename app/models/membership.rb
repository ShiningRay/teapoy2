# coding: utf-8
# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  group_id   :integer
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :user_id, uniqueness: {scope: :group_id}

  validates :user, :group, presence: true
end
