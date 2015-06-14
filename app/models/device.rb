# coding: utf-8
# == Schema Information
#
# Table name: devices
#
#  id        :integer          not null, primary key
#  device_id :string(255)
#  token     :string(255)
#  user_id   :integer
#

class Device < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :device_id
end
