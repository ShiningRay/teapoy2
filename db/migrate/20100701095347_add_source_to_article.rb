# coding: utf-8
class AddSourceToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :source, :string
    add_column :articles, :title, :string
  end

  def self.down
    remove_column :articles, :source
    remove_column :articles, :title
  end
end
