class ChangeAttachmentPostId < ActiveRecord::Migration
  def change
    change_column :attachments, :post_id, :integer
  end
end
