# coding: utf-8
class ConvertSourceToExternalPage < ActiveRecord::Migration
  def change
    Article.where("source is not null and source not like ''").find_each do |article|
      p = article.top_post
      p[:source_link] = article.source
      p[:source_site] = '糗事百科'
      p.save!
      Post.update_all("type='ExternalPage'", :id => p.id)
    end
    remove_column :articles, :source
  end
end
