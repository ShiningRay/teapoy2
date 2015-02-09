# coding: utf-8
class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :role

      t.timestamps
    end
    add_index :memberships, [:user_id, :group_id], :unique => true
  end

  def self.down
    drop_table :memberships
  end
end
