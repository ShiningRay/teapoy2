# coding: utf-8
class CreateQuestLogs < ActiveRecord::Migration
  def change
    create_table :quest_logs do |t|
      t.string :quest_id, :null => false
      t.integer :user_id, :null => false
      t.column :status ,"ENUM('accepted','accomplished', 'abandoned')",:default=>'accepted'
      t.timestamps
    end
  end
end
