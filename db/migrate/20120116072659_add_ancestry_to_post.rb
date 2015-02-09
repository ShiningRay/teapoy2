# coding: utf-8
class AddAncestryToPost < ActiveRecord::Migration
  def change
    add_column :posts, :ancestry, :string
    add_column :posts, :ancestry_depth, :integer, :default => 0
    add_index :posts, :ancestry
    Post.rebuild_missing_tree!
  end
end
