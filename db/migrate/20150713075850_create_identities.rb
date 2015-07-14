class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider, limit: 15, null: false
      t.string :uid, null: false
      t.string :nickname, limit: 50
      t.text :data
    end
    add_index :identities, [:provider, :uid], unique: true
  end
end
