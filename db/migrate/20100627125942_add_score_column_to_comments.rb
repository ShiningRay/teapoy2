# coding: utf-8
class AddScoreColumnToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :pos, :integer
    add_column :comments, :neg, :integer
  end

  def self.down
    remove_column :comments, :pos
    remove_column :comments, :neg
  end
end
