# coding: utf-8
class RemoveActivationCodeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :activation_code
  end
end
