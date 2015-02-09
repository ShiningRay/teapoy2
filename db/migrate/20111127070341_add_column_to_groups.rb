# coding: utf-8
class AddColumnToGroups < ActiveRecord::Migration
 class Group < ActiveRecord::Base

  end
  def change
   add_column :groups, :hide, :boolean, :null => false, :default => false
   add_index :groups,:hide
   Group.reset_column_information
   Group.find_by_id(2).update_attributes!(:hide=>true)
   Group.find_by_id(97).update_attributes!(:hide=>true)
  end
 def self.down
    remove_column :groups, :hide
    remove_index  :groups, :hide
  end
end
