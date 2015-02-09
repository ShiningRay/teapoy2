# coding: utf-8
class ChangeGroupColumns < ActiveRecord::Migration
  def self.up
    add_column :groups, :owner_id, :integer
    remove_column :groups, :domain
    remove_column :groups, :lft
    remove_column :groups, :rgt
    remove_column :groups, :parent_id
  end

  def self.down
    remove_column :groups, :owner_id
    add_column :groups, :domain, :string
    add_column :groups, :parent_id, :integer
    add_column :lft, :parent_id, :integer
    add_column :rgt, :parent_id, :integer
  end
end
