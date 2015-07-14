class CreateUserTokens < ActiveRecord::Migration
  def change
    create_table :user_tokens, force: true do |t|
      t.string :provider, limit: 20, null: true
      t.datetime :expires_at
      t.string :access_token
      t.string :secret
      t.string :uid
      t.string :nickname, limit: 50
      t.integer :identity_id
      t.integer :user_id, null: false
    end
    add_index :user_tokens, [:user_id, :provider], unique: true
    add_index :user_tokens, [:provider, :uid]
  end
end
