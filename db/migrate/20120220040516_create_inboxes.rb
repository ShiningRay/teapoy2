# coding: utf-8
class CreateInboxes < ActiveRecord::Migration
  def change
    create_table :inboxes do |t|
      t.integer :group_id
      t.integer :user_id, :default => 0
      t.integer :article_id
      t.integer :score, :default => 0
      t.boolean :read, :default => false
      t.binary :post_ids

      t.timestamps
    end
    add_index :inboxes, [:group_id, :user_id, :article_id], :unique => true
    add_index :inboxes, [:read, :score]
  end
end
