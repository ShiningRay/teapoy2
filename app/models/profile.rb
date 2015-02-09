# coding: utf-8
class Profile < ActiveRecord::Base
  belongs_to :user
  serialize :value, Hash

end
