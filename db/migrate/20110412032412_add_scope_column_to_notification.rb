# coding: utf-8
class AddScopeColumnToNotification < ActiveRecord::Migration
  def self.up
    remove_index :notifications, :name => :user_id
    add_column :notifications, :scope, :string
    add_index :notifications, :scope
    add_index :notifications, [:user_id, :scope, :key], :unique => true, :name => 'scope'
  end

  def self.down
    remove_column :notifications, :scope
    add_index :notifications, [:user_id, :key], :unique => true
  end
end
