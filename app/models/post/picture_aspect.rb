# picture_aspect.rb

# coding: utf-8
#require 'paperclip_processors'
module Post::PictureAspect
  extend ActiveSupport::Concern
  included do
    mount_uploader :picture, OldPictureUploader, mount_on: :picture_file_name
    attr_accessor :image_url, :dimensions
    # field :image_url, type: String
    # after_post_process :save_image_dimensions
    # field :dimensions, type: Hash, default: {}
    before_save :update_picture_attributes
  end


  def update_picture_attributes
    if picture.present? && picture_changed? && picture.file
      self.content_type = picture.file.content_type
      self.file_size = picture.file.size
    end
  end

  def image_url=(url)
    self.remote_picture_url = url
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
    @gif ||= (self[:picture] =~ /\.gif\z/i)
  end

  def rename(new_file_name)
    (picture.styles.keys+[:original]).each do |style|
        path = picture.path(style)
        FileUtils.move(path, File.join(File.dirname(path), new_file_name))
    end

    self.picture_file_name = new_file_name
    save!
  end

  def as_json(opts={})
    super(opts).merge(
      picture_original_url: picture.url,
      picture_large_url: picture.large.url,
      picture_small_url: picture.small.url,
      picture_small_size: dimensions[:small] || [100,100],
      picture_medium_url: picture.medium.url,
      picture_medium_size: dimensions[:medium] || [100, 100],
      picture_thumb_url: picture.thumb.url)
  end
end
