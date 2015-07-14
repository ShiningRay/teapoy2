class CreateIdentityFollowerships < ActiveRecord::Migration
  def change
    create_table :identity_followerships do |t|
      t.string :uid, null: false
      t.string :follower_uid, null: false
    end

    add_index :identity_followerships, [:uid, :follower_uid], unique: true
  end
end
