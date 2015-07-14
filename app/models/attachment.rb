# coding: utf-8
class Attachment < ActiveRecord::Base
  belongs_to :post
  mount_uploader :file, AttachmentUploader
  # field :content_type, type: String
  # field :file_size, type: Integer
  # field :original_url, type: String
  # field :checksum, type: String
  # field :dimensions, type: Hash, default: {}
  # field :uploader_id, type: Integer
  # index({post_id: 1})

  before_save :update_picture_attributes

  def update_picture_attributes
    if file.present? && file_changed? && file.file
      self.content_type = file.file.content_type
      self.file_size = file.file.size
    end
  end


  def original_url=(url)
    self.remote_file_url = url
    self[:original_url] = url
  end

  def gif?
    @gif ||= (self[:file] =~ /\.gif\z/i)
  end
end

