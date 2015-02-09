# coding: utf-8
class CreateNameLogs < ActiveRecord::Migration
  def self.up
    create_table :name_logs do |t|
      t.string :name
      t.integer :user_id

      t.datetime :created_at
    end
    add_index :name_logs, :user_id
  end

  def self.down
    drop_table :name_logs
  end
end
