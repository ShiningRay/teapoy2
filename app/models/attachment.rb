# coding: utf-8
# == Schema Information
#
# Table name: attachments
#
#  id           :integer          not null, primary key
#  uploader_id  :integer          default(0), not null
#  post_id      :integer          not null
#  file         :string(255)
#  content_type :string(20)
#  file_size    :integer
#  width        :integer          default(0), not null
#  height       :integer          default(0), not null
#  original_url :string(255)
#  checksum     :string(32)
#
# Indexes
#
#  index_attachments_on_post_id      (post_id)
#  index_attachments_on_uploader_id  (uploader_id)
#

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

