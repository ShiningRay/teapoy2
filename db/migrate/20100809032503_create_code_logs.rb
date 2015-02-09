# coding: utf-8
class CreateCodeLogs < ActiveRecord::Migration
  def self.up
    create_table :code_logs, :force => true do |t|
      t.integer :user_id, :null => false
      t.date :date, :null => false
    end
    add_index :code_logs, [:user_id, :date], :unique => true
  end

  def self.down
    drop_table :code_logs
  end
end
