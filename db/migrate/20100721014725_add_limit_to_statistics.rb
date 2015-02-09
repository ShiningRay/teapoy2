# coding: utf-8
class AddLimitToStatistics < ActiveRecord::Migration
  def self.up
    add_column :statistics,:limit,:string
  end

  def self.down
  end
end
