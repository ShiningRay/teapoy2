# coding: utf-8
class MakePostSti < ActiveRecord::Migration
  def self.up
    add_column :posts, :type, :string
    add_column :posts, :group_id, :integer
    add_column :posts, :article_id, :integer
    add_column :posts, :floor, :integer
    add_column :posts, :neg, :integer
    add_column :posts, :pos, :integer
    add_column :posts, :score, :integer
    add_column :posts, :anonymous, :boolean
    add_column :posts, :meta, :string
    remove_column :posts, :reshare
    remove_column :posts, :title
    remove_column :posts, :scope
    add_index :posts, [:group_id, :article_id, :floor], :name => 'pk', :unique => true
    add_column :articles, :top_post_id, :integer
  end

  def self.down
    remove_column :articles, :top_post_id
    add_column :posts, :reshare, :boolean
    add_column :posts, :title, :string
    add_column :posts, :scope, :string
    remove_column :posts, :meta, :string
    remove_column :posts, :neg
    remove_column :posts, :pos
    remove_column :posts, :score
    remove_column :posts, :type
    remove_column :posts, :group_id
    remove_column :posts, :floor
    remove_column :posts, :article_id
    remove_column :posts, :anonymous
  end
end
