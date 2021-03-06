# coding: utf-8
# == Schema Information
#
# Table name: name_logs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime
#
# Indexes
#
#  index_name_logs_on_user_id  (user_id)
#

class NameLog < ActiveRecord::Base
  belongs_to :user
end
