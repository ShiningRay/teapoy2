class ChangePostIdInReward < ActiveRecord::Migration
  def up
    change_column :rewards, :post_id, 'char(24)'
    execute "UPDATE rewards SET post_id = LPAD(post_id, 24, '0')"
  end

  def down
    change_column :rewards, :post_id, :integer, default: 0, null: false
  end
end