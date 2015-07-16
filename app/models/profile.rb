# coding: utf-8
# == Schema Information
#
# Table name: profiles
#
#  id      :integer          not null, primary key
#  user_id :integer
#  value   :text(65535)
#

class Profile < ActiveRecord::Base
  belongs_to :user
  serialize :value, Hash

end
