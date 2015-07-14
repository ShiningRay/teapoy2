# coding: utf-8
class UserToken < ActiveRecord::Base
  # include Mongoid::Document
  # include Tenacity
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :provider
  # field :provider, type: String
  # field :expires_at, type: DateTime
  # field :access_token, type: String
  # field :secret, type: String
  # field :uid, type: String
  # field :nickname, type: String
  belongs_to :identity

  # index({user_id: 1, provider: 1}, {unique: true, background: true})
  # index({provider: 1, uid: 1}, {background: true, sparse: true})

  scope :by_provider, -> (name) { where(provider: name) }

  def self.sina
    by_provider('sina').first
  end

  def client
    @client ||= begin
      c = WeiboOAuth2::Client.new
      c.get_token_from_hash( access_token: access_token, expires_at: expires_at)
      c
    end
  end

  def expired?
    expires_at.try(:past?)
  end
end
