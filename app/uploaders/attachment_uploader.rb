# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # version :thumb do
  #   process resize_to_fill: [64, 64]
  # end

  # version :small do
  #   process resize_to_fit: [256, 256]
  # end

  # version :longsmall do
  #   process resize_to_fit: [200, 1000]
  # end

  # version :medium do
  #   process resize_to_fit: [320, 320]
  # end

  # version :large do
  #   process resize_to_fit: [1024, 1024]
  # end
  def qiniu_async_ops
    commands = []
    %W(small thumb medium longsmall large).each do |style|
      commands << "http://#{self.qiniu_bucket_domain}/#{self.store_dir}/#{self.filename}-#{style}"
    end
    commands
  end

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  #

  process :store_dimensions

  private

  def store_dimensions

    if file && model
      width, height = ::MiniMagick::Image.open(file.file)[:dimensions]
      model.dimensions[:original] = [width, height]
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
