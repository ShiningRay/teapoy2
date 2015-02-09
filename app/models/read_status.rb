# coding: utf-8
class ReadStatus < ActiveRecord::Base
  self.primary_key = 'id'
  belongs_to :user
  belongs_to :article
end
