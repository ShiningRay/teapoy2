# coding: utf-8
# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#

class Tag < ActiveRecord::Base
 validates_length_of    :name, :minimum => 2
 validates_length_of    :name, :maximum => 255
end
