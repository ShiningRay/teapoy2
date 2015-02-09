# coding: utf-8
class CreateSalariesTable < ActiveRecord::Migration
  def up
    create_table "salaries" do |t|
      t.integer     :user_id
      t.integer     :amount
      t.string      :salary_name
      t.date        :salary_date
      t.integer     :status, :default => 0,:null => false
      t.timestamps
    end
    remove_column :transactions, :status
    remove_column :transactions, :salary_date
    add_index "salaries", ["salary_name", "salary_date"], :name => "salary"
  end

  def down
   drop_table :salaries
  end
end
