class AddAnonymousToStory < ActiveRecord::Migration
  def change
    add_column :stories, :anonymous, :boolean, default: false, null: false
  end
end
