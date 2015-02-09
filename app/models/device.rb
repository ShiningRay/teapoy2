# coding: utf-8
class Device < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :device_id
end
