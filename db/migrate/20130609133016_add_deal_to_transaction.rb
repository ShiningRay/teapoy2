class AddDealToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :deal_type, :string
    add_column :transactions, :deal_id, :integer
    add_index :transactions, [:deal_type, :deal_id]
  end
end
