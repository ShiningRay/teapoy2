# coding: utf-8
class AddAdjustToWeight < ActiveRecord::Migration
  def self.up
    add_column :weights, :adjust, :integer
  end

  def self.down
    remove_column :weights, :adjust
  end
end
