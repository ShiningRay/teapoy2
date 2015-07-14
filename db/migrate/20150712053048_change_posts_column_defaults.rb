class ChangePostsColumnDefaults < ActiveRecord::Migration
  def change
    change_column :posts, :topic_id, :integer, null: false, default: 0
    change_column :posts, :user_id, :integer, null: false, default: 0
    change_column :posts, :content, :text, null: false
    change_column :posts, :created_at, :datetime, null: false
    change_column :posts, :updated_at, :datetime, null: false
    change_column :posts, :ip, :integer, null: false, default: 0
    change_column :posts, :neg, :integer, null: false, default: 0
    change_column :posts, :pos, :integer, null: false, default: 0
    change_column :posts, :score, :integer, null: false, default: 0
    change_column :posts, :anonymous, :boolean, null: false, default: false
    change_column :posts, :status, :string, null: false, default: ''
    change_column :posts, :ancestry, :string, null: false, default: ''
    change_column :posts, :ancestry_depth, :integer, null: false, default: 0
  end
end
