# coding: utf-8
class CreateOauthTables < ActiveRecord::Migration
  def change
    create_table :client_applications, force: true do |t|
      t.string :name
      t.string :url
      t.string :support_url
      t.string :callback_url
      t.string :key, :limit => 20
      t.string :secret, :limit => 40
      t.integer :user_id

      t.timestamps
    end
    add_index :client_applications, :key, :unique => true

    create_table :oauth_tokens, force: true do |t|
      t.integer :user_id
      t.string :type, :limit => 20
      t.integer :client_application_id
      t.string :token, :limit => 20
      t.string :secret, :limit => 40
      t.string :callback_url
      t.string :verifier, :limit => 20
      t.timestamp :authorized_at, :invalidated_at
      t.timestamps
    end

    add_index :oauth_tokens, :token, :unique => true

    create_table :oauth_nonces, force: true do |t|
      t.string :nonce
      t.integer :timestamp

      t.timestamps
    end
    add_index :oauth_nonces,[:nonce, :timestamp], :unique => true

  end
end
