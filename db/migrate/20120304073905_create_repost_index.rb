# coding: utf-8
class CreateRepostIndex < ActiveRecord::Migration
  def up
    create_table :post_reposts do |t|
      t.integer :original_group_id
      t.integer :original_article_id
      t.integer :original_id
      t.integer :group_id
      t.integer :article_id
      t.integer :repost_id
      t.integer :sharer_id
    end
    add_index :post_reposts, [:original_id, :group_id], :unique => true, :name => 'key'
    #add_index :post_reposts, [:group_id, :article_id]
    #add_index :post_reposts, [:original_group_id, :original_id]
    add_index :post_reposts, :original_id
    add_index :post_reposts, :repost_id
    add_index :post_reposts, :sharer_id
  end

  def down
    drop_table :post_reposts
  end
end
