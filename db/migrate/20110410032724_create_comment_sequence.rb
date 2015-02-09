# coding: utf-8
class CreateCommentSequence < ActiveRecord::Migration
  def self.up
    execute <<sql

CREATE TABLE  `comment_sequence` (
`article_id` INT NOT NULL ,
`floor` INT NOT NULL AUTO_INCREMENT ,
PRIMARY KEY (  `article_id` ,  `floor` )
) ENGINE = MYISAM ;

sql
  end

  def self.down
    drop_table :comment_sequence
  end
end
