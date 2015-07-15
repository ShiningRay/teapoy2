class AddIndexToPosts < ActiveRecord::Migration
  def change
    add_index :posts, [:topic_id, :parent_floor]
  end
end
