class ChangeArticleIdToTopicId < ActiveRecord::Migration
  def change
    rename_column :read_statuses, :article_id, :topic_id
    rename_column :tickets, :article_id, :topic_id
    rename_column :posts, :article_id, :topic_id
  end
end
