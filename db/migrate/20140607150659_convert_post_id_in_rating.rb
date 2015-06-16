class ConvertPostIdInRating < ActiveRecord::Migration
  def up
    change_column :ratings, :post_id, 'char(24)'
    execute "UPDATE ratings SET post_id = LPAD(post_id, 24, '0')"
    change_column :reputation_logs, :post_id, 'char(24)'
    execute "UPDATE reputation_logs SET post_id = LPAD(post_id, 24, '0')"
  end

  def down
    change_column :ratings, :post_id, :integer, default: 0, null: false
    change_column :reputation_logs, :post_id, :integer, default: 0, null: false
  end
end
