# coding: utf-8
# == Schema Information
#
# Table name: admin_users
#
#  id               :integer          not null, primary key
#  first_name       :string(255)      default(""), not null
#  last_name        :string(255)      default(""), not null
#  role             :string(255)      not null
#  email            :string(255)      not null
#  status           :boolean          default(FALSE)
#  token            :string(255)      not null
#  salt             :string(255)      not null
#  crypted_password :string(255)      not null
#  preferences      :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_admin_users_on_email  (email) UNIQUE
#

class AdminUser < ActiveRecord::Base

#  ROLE = Typus::Configuration.roles.keys.sort
#  LOCALE = Typus.locales

#  enable_as_typus_user

end
