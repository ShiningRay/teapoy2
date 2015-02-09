# coding: utf-8
class AddPerishableTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :perishable_token, :string, :default => "", :null => false
    add_index :users, :perishable_token
  end
end

