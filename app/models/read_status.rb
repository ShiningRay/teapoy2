# coding: utf-8
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

class ReadStatus < ActiveRecord::Base
  include Tenacity
  self.primary_key = 'id'
  belongs_to :user
  t_belongs_to :article
end
