# coding: utf-8
# == Schema Information
#
# Table name: quest_logs
#
#  id       :integer          not null, primary key
#  quest_id :string(255)      not null
#  user_id  :integer          not null
#  status   :string(12)       default("accepted")
#

class QuestLog < ActiveRecord::Base
  belongs_to :user
  def quest
    Quest.find
  end
end
