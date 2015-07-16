# coding: utf-8
# == Schema Information
#
# Table name: code_logs
#
#  id      :integer          not null, primary key
#  user_id :integer          not null
#  date    :date             not null
#
# Indexes
#
#  index_code_logs_on_user_id_and_date  (user_id,date) UNIQUE
#

class CodeLog < ActiveRecord::Base
  def self.ensure_only(user)
    CodeLog.find_by_user_id_and_date(user.id, Date.today)
   end
end
