class CreatePersistenceTokens < ActiveRecord::Migration
  def change
    create_table :persistence_tokens, force: true,  options: "DEFAULT CHARACTER SET latin1" do |t|
      t.integer :user_id, null: false
      t.string :token, null: false, default: ''
      t.string :agent, null: false, default: ''
      # t.decimal :ip
      t.decimal  :ip,      precision: 12, scale: 0, default: 0,        null: false


      t.timestamps
    end
    add_index :persistence_tokens, :token, unique: true
    add_index :persistence_tokens, :user_id
    add_index :persistence_tokens, :updated_at
  end
end
