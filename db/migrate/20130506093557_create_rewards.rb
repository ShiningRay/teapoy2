# coding: utf-8
class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :rewarder_id, :null => false
      t.integer :post_id
      t.integer :winner_id, :null => false
      t.integer :amount
      t.boolean :anonymous, :default => false
      t.timestamps
    end
    add_index :rewards, [:rewarder_id, :post_id], :unique => true
  end
end
