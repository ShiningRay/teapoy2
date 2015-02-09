# coding: utf-8
class AddStatistics < ActiveRecord::Migration
  def self.up
     create_table :statistics do |t|
      t.column :date,                      :date ,:unique=>true
      t.column :all_articles,              :integer
      t.column :publish_articles,          :integer
      t.column :all_comments,              :integer
      t.column :new_users,                 :integer
      t.timestamps
     end
     add_index :statistics ,:date ,:unique=>true
  end

  def self.down
  end
end
