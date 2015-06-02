# coding: utf-8
class Flash < Post
  mount_uploader :swf, FlashUploader
  # has_mongoid_attached_file :swf

  # validates_attachment_content_type :swf,
  #   :content_type => ['application/x-shockwave-flash' ]
  # validates_attachment_size :swf, :less_than => 15.megabytes

  def to_s
    swf.url
  end
end
