# coding: utf-8
class ChangeDateToTime < ActiveRecord::Migration
  def self.up
    rename_column :statistics ,:date,:time
    change_column :statistics,:time,:datetime
  end

  def self.down
  end
end
