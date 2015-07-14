class RemoveTypeMetaFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :type
    remove_column :posts, :meta
  end

  def down
    add_column :posts, :type, :string
    add_column :posts, :meta, :binary
  end
end
