# coding: utf-8
class Badge < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_attached_file :icon,
                    :styles => {
                      :tiny   => '16x16#',
                      :small  => '32x32#',
                      :medium => '64x64#',
                      :large  => '128x128#' },
                    :path => ':rails_root/public/system/badges/:id/:style/:filename',
                    :url => '/system/:class/:id/:style/:filename'
  validates_attachment_content_type :icon,
    :content_type =>
      ['image/jpeg',
       'image/gif',
       'image/png',
       'image/pjpeg',
       'image/bmp',
       'image/x-portable-bitmap'
       ]
  validates_attachment_size :icon, :less_than => 2.megabytes
  validates_uniqueness_of :name

  def self.wrap(name)
    case name
    when Badge
      return name
    when String
      find_by_name name
    when Integer
      find_by_id name
    end
  end
end
