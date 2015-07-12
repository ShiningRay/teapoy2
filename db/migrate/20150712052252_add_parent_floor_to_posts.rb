class AddParentFloorToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :parent_floor, :integer, default: 0
  end
end
