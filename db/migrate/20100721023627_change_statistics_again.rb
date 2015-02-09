# coding: utf-8
class ChangeStatisticsAgain < ActiveRecord::Migration
  def self.up
    remove_column :statistics,:articles
    remove_column  :statistics ,:publish_articles
    remove_column  :statistics ,:comments
    remove_column  :statistics ,:new_users
    add_column     :statistics ,:article_ids,:text
    add_column     :statistics ,:score,:text
  end

  def self.down
  end
end
