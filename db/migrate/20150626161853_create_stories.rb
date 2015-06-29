class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :guestbook_id
      t.integer :author_id
      t.text :content

      t.timestamps
    end

    add_index :stories, [:guestbook_id, :author_id]
  end
end
