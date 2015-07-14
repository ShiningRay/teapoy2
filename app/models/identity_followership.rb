class IdentityFollowership < ActiveRecord::Base
  belongs_to :identity, primary_key: 'uid', foreign_key: 'uid'
  belongs_to :follower, primary_key: 'uid', foreign_key: 'follower_uid'
end