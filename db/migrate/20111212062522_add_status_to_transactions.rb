# coding: utf-8
class AddStatusToTransactions < ActiveRecord::Migration
  def change
   add_column :transactions, :status, :integer,:default=>0,:null => false
   add_column :transactions, :salary_date, :date
  end
end

