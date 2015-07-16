# == Schema Information
#
# Table name: identity_followerships
#
#  id           :integer          not null, primary key
#  uid          :string(255)      not null
#  follower_uid :string(255)      not null
#
# Indexes
#
#  index_identity_followerships_on_uid_and_follower_uid  (uid,follower_uid) UNIQUE
#

class IdentityFollowership < ActiveRecord::Base
  belongs_to :identity, primary_key: 'uid', foreign_key: 'uid'
  belongs_to :follower, primary_key: 'uid', foreign_key: 'follower_uid'
end
