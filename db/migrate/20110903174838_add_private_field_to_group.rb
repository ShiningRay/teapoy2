# coding: utf-8
class AddPrivateFieldToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :private, :boolean, :default => false
  end
end
