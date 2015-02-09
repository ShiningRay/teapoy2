# coding: utf-8
class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :content,                   :text
      t.column :user_id,                   :integer
      t.column :scope,                     :string
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
