# coding: utf-8
class AddFeatureToGroup < ActiveRecord::Migration
   def change
    add_column :groups, :feature, :integer, :default => 0, :null => false
   end
end
