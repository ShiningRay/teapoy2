class AddTopicFields < ActiveRecord::Migration
  def change
    add_column :topics, :views, :integer, null: false, default: 0
  end
end
