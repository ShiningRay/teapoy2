class CreateStoryComments < ActiveRecord::Migration
  def change
    create_table :story_comments do |t|
      t.integer :story_id, null: false
      t.integer :author_id, null: false
      t.text :content

      t.timestamps

    end
    add_index :story_comments, [:story_id, :author_id]
  end
end
