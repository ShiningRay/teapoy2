# coding: utf-8
class ChangeCommentsTableIndexes < ActiveRecord::Migration
  def self.up
    execute <<sql
   ALTER TABLE `comments` DROP INDEX `article_id_created_at_status`
sql
    ['created_at', 'status', 'article_id'].each do |f|
      remove_index :comments, f
    end
  end

  def self.down
  end
end
