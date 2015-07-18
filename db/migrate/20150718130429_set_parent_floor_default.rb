class SetParentFloorDefault < ActiveRecord::Migration
  def change
    change_column :posts, :parent_floor, :integer, default: 0
  end
end
