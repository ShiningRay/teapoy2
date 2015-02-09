# coding: utf-8
class MigrateDatas < ActiveRecord::Migration
  def self.up
    rename_column :ratings, :article_id, :post_id rescue nil
    execute 'TRUNCATE TABLE  `comment_sequence`'
    Post.migrate_from_comments
  end

  def self.down
  end
end
