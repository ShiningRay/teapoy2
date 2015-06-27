class AddLikesCountToStory < ActiveRecord::Migration
  def change
    add_column :stories, :likes_count, :integer, null: false, default: 0
  end
end
