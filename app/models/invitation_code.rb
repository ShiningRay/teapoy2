# coding: utf-8
# == Schema Information
#
# Table name: invitation_codes
#
#  id           :integer          not null, primary key
#  code         :string(255)      not null
#  applicant_id :integer          not null
#  consumer_id  :integer
#  created_at   :datetime
#  consumed_at  :datetime
#  updated_at   :datetime
#

require 'digest/md5'
class InvitationCode < ActiveRecord::Base
  belongs_to :applicant, :class_name => 'User'
  belongs_to :consumer, :class_name => 'User'
  validates_uniqueness_of :code
  def self.generate(user_id, amount)
    a = []
    amount.times do
      digest = Digest::MD5.digest("#{user_id}--#{Time.now}--#{rand()}")
      code = digest.unpack("N*").map{|i|i.to_s(36)}.join[0,16]
      a << create( :applicant_id => user_id, :code => code.upcase)
    end
    a
  end
end
