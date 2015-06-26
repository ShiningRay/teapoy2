class CreateGuestbooks < ActiveRecord::Migration
  def change
    create_table :guestbooks do |t|
      t.string :name, null: false
      t.integer :owner_id, null: false
      t.text :description

      t.timestamps
    end
    add_index :guestbooks, :name, unique: true
    add_index :guestbooks, :owner_id
  end
end
