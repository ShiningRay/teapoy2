# coding: utf-8
class AddReadToNotification < ActiveRecord::Migration
  def self.up
    add_column :notifications, :read, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :notifications, :read
  end
end
