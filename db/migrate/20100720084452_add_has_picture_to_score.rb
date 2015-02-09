# coding: utf-8
class AddHasPictureToScore < ActiveRecord::Migration
  def self.up
     add_column :scores, :has_picture, :boolean, :null => false, :default => false
  end

  def self.down
  end
end
