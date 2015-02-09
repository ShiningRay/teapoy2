# coding: utf-8
class AlterUsersForAuthlogic < ActiveRecord::Migration
  def self.up
    #remove_column :users, :name
    #change_column :users, :email, :string, :default => "", :null => false, :limit => 128
    #rename_column :users, :crypted_password, :encrypted_password
    #change_column :users, :encrypted_password, :string, :limit => 128, :default => "", :null => false
    #rename_column :users, :salt, :password_salt
    #change_column :users, :password_salt, :string, :default => "", :null => false, :limit => 255
    add_column :users, :persistence_token, :string, :null => false
    add_column :users, :login_count, :integer, :default => 0
    add_column :users, :current_login_at, :datetime
    add_column :users, :last_login_at, :datetime
    add_column :users, :last_request_at, :datetime
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string
  end

  def self.down
    remove_column :users, :persistence_token
    remove_column :users, :login_count, :integer
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :last_request_at
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_ip
  end
end
