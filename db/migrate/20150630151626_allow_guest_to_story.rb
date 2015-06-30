class AllowGuestToStory < ActiveRecord::Migration
  def change
    change_column :stories, :author_id, :integer, null: true, default: nil
    add_column :stories, :email, :string, limit: 64
    add_index :stories, :email
  end
end
