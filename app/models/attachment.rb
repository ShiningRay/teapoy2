# coding: utf-8
class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :post
  mount_uploader :file, AttachmentUploader
  field :content_type, type: String
  field :file_size, type: Integer
  field :original_url, type: String
  field :checksum, type: String
  field :dimensions, type: Hash, default: {}
  field :uploader_id, type: Integer
  index({post_id: 1})

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

  def dim_size(style=:original)
    d = dimensions[style]
    d && "#{d[0].to_i}x#{d[1].to_i}"
  end

  def width(style=:original)
    dimensions[style][0]
  end

  def height(style=:original)
    dimensions[style][1]
  end

  def dim_style_size(style=:original)
    d = dimensions[style]
    d && "width:#{d[0].to_i}px;height:#{d[1].to_i}px;"
  end

  def gif?
    @gif ||= (self[:file] =~ /\.gif\z/i)
  end
end
