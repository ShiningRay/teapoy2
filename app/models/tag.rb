# coding: utf-8
class Tag < ActiveRecord::Base
 validates_length_of    :name, :minimum => 2
 validates_length_of    :name, :maximum => 255
end