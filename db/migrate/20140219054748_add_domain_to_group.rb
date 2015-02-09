class AddDomainToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :domain, :string
    add_index :groups, :domain, :unique => true
  end
end
