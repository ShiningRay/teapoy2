# coding: utf-8
class ChangeProfileTable < ActiveRecord::Migration
  def up
    remove_column :profiles, :realname
    remove_column :profiles, :phonenumber
    remove_column :profiles, :sex
    remove_column :profiles, :job
    remove_column :profiles, :birthday
    remove_column :profiles, :created_at
    remove_column :profiles, :updated_at
    add_column :profiles, :value, :text
  end

  def down

  end
end
