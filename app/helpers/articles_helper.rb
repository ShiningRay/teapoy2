# -*- encoding: utf-8 -*-
module ArticlesHelper
  def navigator

  end

  def embed_article(group_id, article_slug)
    cache [group_id, article_slug, :content] do
      group = Group.wrap group_id
      article = group.articles.wrap article_slug
      article.content
    end
  end

  def groups_select
    groups = current_user.publications(Group)
    concat f.input( :group, :label => '小组', :as => :select, :collection => groups, :include_blank => false, :prompt => '请选择一个小组')
    if groups.size == 0
      concant '您还没加入任何小组，'
      concat link_to( '赶紧去找一个找自己喜欢的吧', groups_path)
    end
  end

  def article_title(article=@article, max_len=20)
    article.article_title(max_len)
  end

  def article_page?
    controller_name == 'articles' and action_name == 'show'
  end

  def article_author(article=@article)
    user = article.user
    if user.id != 0 && !article.anonymous
      user.name_or_login
    else
      '匿名人士'
    end
  end

  def topic_owenr_class(article=@article)
    @list_view || article.anonymous ? '' : 'topic-owner'
  end

  def show_tags(article, current_tag = nil)
    tag = article.tag_line
    return if tag.blank?
    m = {}
    r = article.tags.collect do |t|
      t = t.name
      l = link_to t, {:controller => :groups, :action => :tag, :id => article.group.id, :tag => t}, {:rel => 'tag'}
      l = content_tag :span, l, :class => 'current_tag' if current_tag and t.include? current_tag
      m[t]= l
      "(#{Regexp.escape(t)})"
    end
    reg = Regexp.new(r.join('|'))
    tag.gsub reg do |t|
      m[t]
    end
  end
end
