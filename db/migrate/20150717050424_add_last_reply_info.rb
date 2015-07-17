class AddLastReplyInfo < ActiveRecord::Migration
  def change
    change_table :topics do |t|
      t.datetime :last_posted_at, null: false
      t.integer :last_poster_id
    end
    add_index :topics, :last_posted_at
    execute 'update topics set last_posted_at=updated_at'
  end
end
