# coding: utf-8
class CreateReputations < ActiveRecord::Migration
  def change
    create_table :reputations do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :value, :default => 0
      t.string :state, :default => 'neutral'
      t.boolean :hide, :default => false
      #t.timestamps
    end
    add_index :reputations, [:group_id, :user_id], :unique => true
  end
end
