class CreateGroupOptions < ActiveRecord::Migration
  def change
    create_table :group_options do |t|
      t.integer :group_id, null: false
      t.string :receive_group_email_frequency, default:'day'
      t.boolean :only_member_can_view, default: false
      t.boolean :only_member_can_post, default: false
      t.boolean :membership_need_approval, default: false
      t.boolean :only_member_can_reply, default: false
      t.boolean :topics_need_approval, default: false
      t.boolean :comments_need_approval, default: false
      t.boolean :force_comments_anonymous, default: false
      t.boolean :force_anonymous, default: false
      t.boolean :encryption, default: false
      t.string :score_algorithm
      t.string :css
      t.string :seo_keywords
      t.string :seo_description
      t.string :background
      t.string :background_style
      t.boolean :guest_can_post, default: false
      t.boolean :guest_can_reply, default: false
    end
    add_index :group_options, :group_id
  end
end
