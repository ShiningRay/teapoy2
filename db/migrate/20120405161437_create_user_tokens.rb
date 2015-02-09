# coding: utf-8
class CreateUserTokens < ActiveRecord::Migration
  def up
    create_table :user_tokens do |t|
      t.integer :user_id
      t.string :client_name
      t.string  :token_key
      t.string  :token_secret
    end
    add_index :user_tokens, [:client_name,:token_key, :token_secret], :unique => true, :name => 'key'
  end

  def down
    drop_table :user_tokens
  end
end
