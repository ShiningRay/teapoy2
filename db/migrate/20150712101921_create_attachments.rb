class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :uploader_id, null: false, default: 0
      t.string :post_id, limit: 32
      t.string :file
      t.string :content_type, limit: 20
      t.integer :file_size
      t.integer :width, default: 0, null: false
      t.integer :height, default: 0, null: false
      t.string :original_url
      t.string :checksum, limit: 32
    end
    add_index :attachments, :post_id
    add_index :attachments, :uploader_id
  end
end
