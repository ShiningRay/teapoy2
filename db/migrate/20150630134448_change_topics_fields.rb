class ChangeTopicsFields < ActiveRecord::Migration
  def change
    remove_column :topics, :cached_slug
  end
end
