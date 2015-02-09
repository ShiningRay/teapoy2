# coding: utf-8
class CreateBalances < ActiveRecord::Migration
  def self.up
    create_table :balances do |t|
      t.integer :user_id, :null => false
      t.integer :charm, :null => false, :default => 0
      t.integer :credit, :null => false, :default => 0
      t.integer :level, :null => false, :default => 0

      t.timestamps
    end
    add_index :balances, :user_id, :unique => true

  end

  def self.down
    drop_table :balances
  end
end
