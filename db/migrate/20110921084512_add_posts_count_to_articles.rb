# coding: utf-8
class AddPostsCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :posts_count, :integer, :default => 0
    Post.select("count(*) as posts_count, article_id").group("article_id").includes(:article).each do |post|
      if post.article
        post.article[:posts_count] = post[:posts_count]
        post.article.save!
      end
    end
  end
end
