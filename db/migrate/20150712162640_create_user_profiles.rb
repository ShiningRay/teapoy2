class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id, null: false
      t.string :sex, default: ''
      t.date :birthday
      t.string :hometown
      t.string :bio
      t.boolean :want_receive_notification_email, null: false, default: true
    end
    add_index :user_profiles, :user_id, unique: true
  end
end
