# coding: utf-8
class AddFloorIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :floor, :integer
    add_column :comments, :score, :integer
    add_index :comments, [:article_id, :floor], :unique => true
    add_index :comments, [:article_id, :score]
  end

  def self.down
    remove_column :comments, :floor
    remove_column :comments, :score
  end
end
