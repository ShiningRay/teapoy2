class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :created_at, :avatar, :user_url#, :message_url

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

  def user_url
    Rails.application.routes.url_helpers.user_path(object)
  end
end
