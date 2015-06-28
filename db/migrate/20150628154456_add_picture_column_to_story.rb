class AddPictureColumnToStory < ActiveRecord::Migration
  def change
    add_column :stories, :picture, :string
  end
end
