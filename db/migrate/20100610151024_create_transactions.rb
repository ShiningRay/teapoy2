# coding: utf-8
class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|

      t.integer :balance_id ,:null => false
      t.integer :amount, :null => false, :default => 0
      t.string :reason

      t.datetime :created_at
    end
    add_index :transactions, [:balance_id, :created_at]
  end

  def self.down
    drop_table :transactions
  end
end
