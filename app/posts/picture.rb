# coding: utf-8
require 'net/http'
require 'uri'
require 'open-uri'
#require 'paperclip_processors'
class Picture < Post
  has_mongoid_attached_file :picture,
    styles: {
      thumb: {
        geometry: '64x64#',
        animated: false,
        position: 'northwest',
        watermark_path: "#{Rails.root}/public/images/gif_play.png",
        processors: [:thumbnail, :gif_watermark]
      },
      small: {
        geometry: '256x256>',
        animated: false,
      },
      longsmall: {
        geometry: '200x1000>',
        animated: false
      },
      medium: {
          geometry: '320x320>',
          watermark_path: "#{Rails.root}/public/images/watermark-small.png",
          position: 'Southwest',
          animated: false,
          processors: [:thumbnail, :watermark],
        },
      large: {
          geometry: '1024>',
          watermark_path: "#{Rails.root}/public/images/watermark.png",
          position: 'northwest',
          animated: false,
          processors: [:thumbnail, :watermark],
        }
    },
   path: ":rails_root/public/system/:attachment/:oid/:style/:filename",
   url: "/system/:attachment/:oid/:style/:filename"


  validates_attachment_content_type :picture,
    content_type: %w(image/jpeg image/gif image/png image/pjpeg image/bmp image/x-portable-bitmap)
  validates_attachment_size :picture, less_than: 10.megabytes
  #skip_callback :create, :before, :detect_parent
  #skip_callback :create, :create_notification, :comment_notify
  #process_in_background :picture
  #handle_asynchronously :save_attached_files
  field :image_url, type: String
  before_save :fetch_image, if: :image_url
=begin
  before_create :correct_filename_encoding

  def correct_filename_encoding
    unless picture.file.name.valid_encoding?
      extension = File.extname(picture_file_name).downcase
      picture.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
    end
  end
=end
  def fetch_image
    return if picture.file? or image_url.blank?
    url = URI.parse(image_url)
    filename = File.basename url.path
    file = File.new File.join(Rails.root, 'tmp', filename), 'wb+'
    begin
    file.write open(image_url).read
    rescue
      rescue OpenURI::HTTPError
    end
    self.picture = file
  rescue URI::InvalidURIError
  end

  def to_s
    picture.url(:original)
  end

  after_post_process :save_image_dimensions
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

  def save_image_dimensions
    self.dimensions ||= { }
    picture.queued_for_write.each do |name, file|
      #puts picture.queued_for_write[:longsmall].path
      geo = Paperclip::Geometry.from_file(file)
      self.dimensions[name] = [geo.width, geo.height]
    end
  rescue ::Paperclip::NotIdentifiedByImageMagickError
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
      unless p.picture.file?
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

  protected :save_image_dimensions

  def as_json(opts={})
    super(opts).merge(
      picture_original_url: picture(:original),
      picture_large_url: picture(:large),
      picture_small_url: picture(:small),
      picture_small_size: dimensions[:small] || [100,100],
      picture_medium_url: picture(:medium),
      picture_medium_size: dimensions[:medium] || [100, 100],
      picture_thumb_url: picture(:thumb))
  end
end
