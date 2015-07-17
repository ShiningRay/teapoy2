# coding: utf-8
# == Schema Information
#
# Table name: user_tokens
#
#  id           :integer          not null, primary key
#  provider     :string(20)
#  expires_at   :datetime
#  access_token :string(255)
#  secret       :string(255)
#  uid          :string(255)
#  nickname     :string(50)
#  identity_id  :integer
#  user_id      :integer          not null
#
# Indexes
#
#  index_user_tokens_on_provider_and_uid      (provider,uid)
#  index_user_tokens_on_user_id_and_provider  (user_id,provider) UNIQUE
#

class UserToken < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :provider
  belongs_to :identity

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
