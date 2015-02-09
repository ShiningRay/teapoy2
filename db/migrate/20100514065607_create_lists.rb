# coding: utf-8
class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.string :name, :null => false
      t.integer :user_id, :null => false
      t.boolean :private, :null => false, :default => false
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
