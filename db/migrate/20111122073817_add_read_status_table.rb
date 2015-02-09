# coding: utf-8
class AddReadStatusTable < ActiveRecord::Migration
  def up
    create_table 'read_statuses' do |t|
      t.integer :user_id , :null => false
      t.integer :group_id
      t.integer :article_id, :null => false
      t.integer :read_to, :default => 0
      t.datetime :read_at
      t.integer :updates, :default => 0
    end
    add_index 'read_statuses', [:user_id, :group_id, :article_id], :name => 'alter_pk', :unique => true
    add_index 'read_statuses', [:user_id, :group_id, :article_id, :read_to], :name => 'total_index'
  end

  def down
    drop_table 'read_statuses'
  end
end
