# coding: utf-8
class AddViewColumnToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :viewed_at, :datetime
  end

  def self.down
    remove_column :tickets, :viewed_at, :datetime
  end
end
