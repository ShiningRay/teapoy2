# coding: utf-8
# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Tag < ActiveRecord::Base
 validates_length_of    :name, :minimum => 2
 validates_length_of    :name, :maximum => 255
end
