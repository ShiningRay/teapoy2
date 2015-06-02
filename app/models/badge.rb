# coding: utf-8
class Badge < ActiveRecord::Base
  has_and_belongs_to_many :users
  mount_uploader :icon, AvatarUploader, mount_on: :icon_file_name
  
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
