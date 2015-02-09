# coding: utf-8
class CreateReputationLogs < ActiveRecord::Migration
  def change
    create_table :reputation_logs, :force => true do |t|
      t.integer :reputation_id
      t.integer :user_id
      t.integer :group_id
      t.integer :post_id
      t.integer :amount
      t.string :reason
      t.date :created_on
      t.timestamps
    end
    add_index :reputation_logs, :reputation_id
    add_index :reputation_logs, [:group_id, :user_id]
    add_index :reputation_logs, :post_id
    add_index :reputation_logs, :created_on
  end
end
