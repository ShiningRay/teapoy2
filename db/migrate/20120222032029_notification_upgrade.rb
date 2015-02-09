# coding: utf-8
class NotificationUpgrade < ActiveRecord::Migration
  def up
    Notification.delete_all
    #add_index :notifications_sources, [:notification_id, :source_type, :source_id], :unique => true
    add_column :notifications, :subject_type, :string rescue nil
    add_column :notifications, :subject_id, :integer rescue nil 
    add_index :notifications, [:subject_type, :subject_id] rescue nil
    add_index :notifications, [:user_id, :scope, :subject_type, :subject_id], :name => 'key1' rescue nil
    add_column :notifications, :count, :integer, :default => 1 rescue nil
    remove_index :notifications, [:user_id, :scope] rescue nil
    #remove_column :notifications, :content
    remove_column :notifications, :key rescue nil
  end

  def down
    add_column :notifications, :content, :text
    add_column :notifications, :key, :string
    remove_column :notifications, :subject_type
    remove_column :notifications, :subject_id
    remove_column :notifications, :actor_id
  end
end
