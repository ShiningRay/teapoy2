# coding: utf-8
class SetDefaultValueToAnonymousColumn < ActiveRecord::Migration
  def self.up
    change_column :articles, :anonymous, :boolean, :null => false, :default => false
  end

  def self.down
  end
end
