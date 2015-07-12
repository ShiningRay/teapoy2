class AddMentionedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :mentioned, :string
  end
end
