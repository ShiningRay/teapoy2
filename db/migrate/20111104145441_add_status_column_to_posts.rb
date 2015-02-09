# coding: utf-8
class AddStatusColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :status, :string
  end
end

