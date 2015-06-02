module User::AvatarAspect
  extend ActiveSupport::Concern
  #include Mongoid::Paperclip

  included do
    mount_uploader :avatar, AvatarUploader, mount_on: :avatar_file_name
    # has_mongoid_attached_file :avatar,
    # has_attached_file :avatar,
    #                   styles: { #medium: "320x320>",
    #                         small: "64x64#",
    #                         #thumb: "32x32#" }
    #                         medium: "200x200>",
    #                         thumb: '32x32#' },
    #                   path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    #                   url: "/system/:attachment/:id/:style/:filename"
    # validates_attachment_content_type :avatar,
    #                                   content_type: %w(image/jpeg image/gif image/png image/pjpeg image/bmp image/x-portable-bitmap),
    #                                   unless: -> (model) {model.avatar}
    # validates_attachment_size :avatar, less_than: 2.megabytes, unless: -> (model) {model.avatar}
  end
end
