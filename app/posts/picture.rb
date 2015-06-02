# coding: utf-8
#require 'paperclip_processors'
class Picture < Post
  mount_uploader :picture, PictureUploader, mount_on: :picture_file_name

  before_save :update_picture_attributes

  def update_picture_attributes
    if picture.present? && picture_changed? && picture.file
      self.content_type = picture.file.content_type
      self.file_size = picture.file.size
    end
  end

  field :image_url, type: String

  def image_url=(url)
    self.remote_picture_url = url
    self[:image_url] = url
  end

  def to_s
    picture.original.url
  end

  # after_post_process :save_image_dimensions
  field :dimensions, type: Hash, default: {}

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
    @gif ||= (picture.content_type =~ /gif/i)
  end

  def self.downgrade_empty
    ids = []
    down = Proc.new do
      Picture.connection.execute "update posts set `type`=NULL where `type` like 'Picture' and `id` IN(#{ids.join(',')})"
      ids = []
    end
    Picture.find_each do |p|
      unless p.picture?
        ids << p.id
        p.meta = {}
        p.save!
      end
      down.call if ids.size > 1000
    end
    down.call
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
      picture_original_url: picture.original.url,
      picture_large_url: picture.large.url,
      picture_small_url: picture.small.url,
      picture_small_size: dimensions[:small] || [100,100],
      picture_medium_url: picture.medium.url,
      picture_medium_size: dimensions[:medium] || [100, 100],
      picture_thumb_url: picture.thumb.url)
  end
end
