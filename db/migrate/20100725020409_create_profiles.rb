# coding: utf-8
class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.string :realname
      t.string :phonenumber
      t.column :sex ,"ENUM('boy','girl','unknown')",:default=>'unknown'
      t.string :job
      t.date :birthday

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
