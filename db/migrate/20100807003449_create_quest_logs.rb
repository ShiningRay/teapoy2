# coding: utf-8
class CreateQuestLogs < ActiveRecord::Migration
  def self.up
    create_table :quest_logs do |t|
      t.string :quest_id, :null => false
      t.integer :user_id, :null => false
      t.column :status ,"ENUM('accepted','accomplished', 'abandoned')",:default=>'accepted'
      t.timestamps!
    end
  end

  def self.down
    drop_table :quest_logs
  end
end
