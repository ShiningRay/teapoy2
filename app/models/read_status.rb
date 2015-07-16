# coding: utf-8
# == Schema Information
#
# Table name: read_statuses
#
#  id       :integer          not null, primary key
#  user_id  :integer          not null
#  group_id :integer
#  topic_id :integer          not null
#  read_to  :integer          default(0)
#  read_at  :datetime
#  updates  :integer          default(0)
#
# Indexes
#
#  alter_pk     (user_id,group_id,topic_id) UNIQUE
#  total_index  (user_id,group_id,topic_id,read_to)
#

class ReadStatus < ActiveRecord::Base
  self.primary_key = 'id'
  belongs_to :user
  belongs_to :topic
end
