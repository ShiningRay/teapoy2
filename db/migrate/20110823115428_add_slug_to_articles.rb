# coding: utf-8
class AddSlugToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :slug_name, :string
    add_index :articles, :slug_name
    change_column :posts, :meta, :text
  end
end
