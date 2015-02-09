class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :owner_id, null: false
      t.integer :target_id, null: false
      t.integer :messages_count, default: 0
      t.string :last_content
      t.timestamps
    end

    add_index :conversations, [:owner_id, :target_id], unique: true
  end
end
