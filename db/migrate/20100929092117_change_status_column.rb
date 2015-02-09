class ChangeStatusColumn < ActiveRecord::Migration
  def self.up
    execute "update articles set status='' where status='spam'"
    execute "update comments set status='' where status='spam' or status = 'private'"
    execute "update articles set status='' where group_id = 1 and status = 'private'"
    execute <<sql
    ALTER TABLE  `articles` CHANGE  `status`  `status` ENUM(  'publish', 'private', 'pending', 'spam') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT  'pending'
sql
    execute <<sql
    ALTER TABLE  `comments` CHANGE  `status`  `status` ENUM(  'publish', 'pending', 'private', 'spam') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT  'pending'
sql

    ActsAsArchive.update Article, Comment
    Article.delete_all "status = '' or status = 'spam'"
    Comment.delete_all "status = '' or status = 'spam' or status = 'private'"
    Article.delete_all "group_id = 1 and status = 'private'"
    Article.delete_all "status = 'private' and user_id = 0"
  end

  def self.down
  end
end
