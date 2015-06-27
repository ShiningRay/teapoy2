class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :story_id

      t.timestamps
    end
    add_index :likes, [:story_id, :user_id], unique: true
  end
end
