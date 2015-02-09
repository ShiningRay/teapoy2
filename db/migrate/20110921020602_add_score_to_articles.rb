# coding: utf-8
class AddScoreToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :score, :integer, :default => 0
  end
end
