# coding: utf-8
class ChangeIndexInStatistics < ActiveRecord::Migration
  def self.up
     remove_index :statistics ,:date
     add_index  :statistics ,[:time, :limit], :unique => true
  end

  def self.down
  end
end
