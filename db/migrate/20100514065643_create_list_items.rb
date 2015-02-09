# coding: utf-8
class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items do |t|
      t.integer :article_id, :null => false
      t.integer :list_id, :null => false
      t.integer :position, :null => false, :default => 0
      t.string :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :list_items
  end
end
