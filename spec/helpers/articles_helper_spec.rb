# coding: utf-8
require 'rails_helper'

describe ArticlesHelper do
  describe '#embed_article', broken: true do
    let(:group) { create :group }
    let(:user){ create :user }
    it 'should show article' do
      article = Article.new( :group_id => group.id,
                       :title => 'test',
                       :top_post_attributes => {
                           :content => '@test'})
      article.status = 'publish'
      article.save(:validate => false)
      # $stderr << article.inspect
      # $stderr << group.inspect
      content = helper.embed_article(article.group.alias, article.slug)
      expect(content).to eq(article.content)
    end
  end
end
