class ChangeRatingPostId < ActiveRecord::Migration
  def change
    change_column :ratings, :post_id, :integer, null: false
  end
end
