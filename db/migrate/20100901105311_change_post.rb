# coding: utf-8
class ChangePost < ActiveRecord::Migration
  def self.up
    add_column :posts, :parent_id, :integer
    add_column :posts, :reshare, :boolean, :null => false, :default => false
    add_column :posts, :ip, :integer
    add_column :posts, :title, :string
    add_column :posts, :source, :string
    add_column :posts, :device, :string
    add_index :posts, [:reshare, :parent_id]
  end

  def self.down
    remove_column :posts, :parent_id, :reshare, :ip, :title, :source, :device
  end
end
