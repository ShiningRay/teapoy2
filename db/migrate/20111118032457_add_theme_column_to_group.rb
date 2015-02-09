# coding: utf-8
class AddThemeColumnToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :theme, :string
  end
end
