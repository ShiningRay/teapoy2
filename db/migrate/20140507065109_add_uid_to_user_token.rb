class AddUidToUserToken < ActiveRecord::Migration
  def change
    add_column :user_tokens, :uid, :string
  end
end
