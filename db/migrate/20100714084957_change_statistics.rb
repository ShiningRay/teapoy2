# coding: utf-8
class ChangeStatistics < ActiveRecord::Migration
  def self.up
   rename_column :statistics, :all_articles, :articles
   rename_column :statistics, :all_comments, :comments
  end

  def self.down
  end
end
