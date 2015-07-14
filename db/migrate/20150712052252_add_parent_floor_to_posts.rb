class AddParentFloorToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :parent_floor, :integer
  end
end
