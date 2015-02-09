class AddExpiresAtToUserToken < ActiveRecord::Migration
  def change
    add_column :user_tokens, :expires_at, :datetime
  end
end
