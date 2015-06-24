# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(255)      not null
#  email                     :string(255)      not null
#  crypted_password          :string(255)      not null
#  salt                      :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  remember_token            :string(255)      default(""), not null
#  remember_token_expires_at :datetime
#  activated_at              :datetime
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  state                     :string(255)      default("passive")
#  deleted_at                :datetime
#  name                      :string(100)
#  persistence_token         :string(255)      not null
#  login_count               :integer          default(0)
#  current_login_at          :datetime
#  last_login_at             :datetime
#  last_request_at           :datetime
#  current_login_ip          :string(255)
#  last_login_ip             :string(255)
#  perishable_token          :string(255)      default(""), not null
#  avatar_fingerprint        :string(255)
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :created_at, :avatar, :user_url, :avatar_url#, :message_url

  def avatar
    if object.avatar?
      {
        small: (object.avatar.small.url),
        medium: (object.avatar.medium.url),
        thumb: (object.avatar.thumb.url),
        original: (object.avatar.url)
      }
    else
      {

      }
    end
  end

  def avatar_url
    object.avatar.medium.url if object.avatar?
  end

  def user_url
    Rails.application.routes.url_helpers.user_path(object)
  end
end
