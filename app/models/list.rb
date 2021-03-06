# coding: utf-8
# == Schema Information
#
# Table name: lists
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  user_id    :integer          not null
#  private    :boolean          default(FALSE), not null
#  notes      :text(65535)
#  created_at :datetime
#  updated_at :datetime
#

class List < ActiveRecord::Base
  # include Mongoid::Document
  # include Mongoid::Timestamps
  # has_many :items, :class_name => 'ListItem', :order => 'position'
  belongs_to :user
  # has_many :topics, :through => :items
end
