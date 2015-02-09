# coding: utf-8
class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id
      t.string :token
      t.integer :user_id

      #t.timestamps
    end
    add_index :devices, :token
    add_index :devices, :device_id
    add_index :devices, :user_id
  end
end
