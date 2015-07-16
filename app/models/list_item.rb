# coding: utf-8
# == Schema Information
#
# Table name: list_items
#
#  id         :integer          not null, primary key
#  article_id :integer          not null
#  list_id    :integer          not null
#  position   :integer          default(0), not null
#  notes      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ListItem < ActiveRecord::Base
  belongs_to :list
  belongs_to :topic
  acts_as_list :scope => :list
end
