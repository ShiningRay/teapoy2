# coding: utf-8
# == Schema Information
#
# Table name: badges
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  title             :string(255)      not null
#  description       :string(255)
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  icon_updated_at   :datetime
#
# Indexes
#
#  index_badges_on_name  (name) UNIQUE
#

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
