# coding: utf-8
class AddPosNegCorrectToWeight < ActiveRecord::Migration
  def self.up
    add_column :weights, :pos_correct, :integer
    add_column :weights, :neg_correct, :integer
  end

  def self.down
    remove_column :weights, :pos_correct
    remove_column :weights, :neg_correct
  end
end
