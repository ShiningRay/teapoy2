# coding: utf-8
class ChangeAdjustFromIntToFloat < ActiveRecord::Migration
  def self.up
    change_column :weights, :adjust, :float

  end

  def self.down
  end
end
