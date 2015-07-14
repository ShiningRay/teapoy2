class ChangeRewardPostId < ActiveRecord::Migration
  def change
    change_column :rewards, :post_id, :integer, null: false
  end
end
