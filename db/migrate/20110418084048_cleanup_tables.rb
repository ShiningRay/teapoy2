# coding: utf-8
class CleanupTables < ActiveRecord::Migration
  def self.up
    remove_column :articles, :content
    remove_column :articles, :ip
    remove_column :articles, :picture_content_type
    remove_column :articles, :picture_file_name
    remove_column :articles, :picture_file_size
    remove_column :articles, :picture_updated_at
    remove_column :articles, :email
    drop_table :scores
    drop_table :comments
    drop_table :favorites rescue nil
    drop_table :weights rescue nil
    drop_table :comment_ratings rescue nil
    drop_table :pictures rescue nil
    drop_table :statistics rescue nil
    drop_table :article_references rescue nil
  end

  def self.down
  end
end
