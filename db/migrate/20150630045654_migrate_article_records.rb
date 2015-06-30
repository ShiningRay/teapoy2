class MigrateArticleRecords < ActiveRecord::Migration
  def change
    rename_table :articles, :topics
    Subscription.where(:publication_type => 'Article').update_all(:publication_type => 'Topic')
  end
end
