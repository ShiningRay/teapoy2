# coding: utf-8
class List < ActiveRecord::Base
  # include Mongoid::Document
  # include Mongoid::Timestamps
  # has_many :items, :class_name => 'ListItem', :order => 'position'
  belongs_to :user
  # has_many :articles, :through => :items
end
