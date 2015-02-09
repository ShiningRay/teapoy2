class AddTargetIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :target_id, :integer
    add_index :messages, [:owner_id, :target_id]
  end
end
