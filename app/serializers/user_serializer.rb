class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :created_at, :avatar, :user_url#, :message_url

  def avatar
    if object.avatar.file?
      {
        small: full_path(object.avatar.url(:small)),
        medium: full_path(object.avatar.url(:medium)),
        thumb: full_path(object.avatar.url(:thumb)),
        original: full_path(object.avatar.url(:original))
      }
    else
      {

      }
    end
  end

  def user_url
    Rails.application.routes.url_helpers.user_path(object)
  end

  def full_path(p)
    if ActionController::Base.asset_host.present?
      h = ActionController::Base.asset_host.respond_to?(:call) ? ActionController::Base.asset_host.call : ActionController::Base.asset_host.to_s
      File.join(h, p)
    else
      p
    end
  end
end
