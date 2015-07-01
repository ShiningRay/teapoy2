# encoding: utf-8
module SeoMethods
  def keywords
    @keywords ||= Set.new
  end

  def prepend_keywords(*new_keywords)
    @keywords ||= Set.new
    @keywords = Array(new_keywords).flatten + keywords
  end

  def append_keywords(*new_keywords)
    @keywords ||= Set.new
    @keywords += Array(new_keywords).flatten
  end

  def description
    @description
  end

  def append_description *desc
    @description ||= ''
    @description << '. '
    @description << desc.flatten.join('. ')
    @description << '. '
  end

  def seo_for_group(group=@group)
    append_description @group.description, @group.options[:seo_description]
    append_keywords @group.options[:seo_keywords], @group.name
  end

  def seo_for_article(article=topic)
# =>     prepend_title "\##{topic.id}"
    seo_for_group(article.group)
    seo_for_user(article.user) unless article.anonymous?
    append_keywords article.created_at.strftime("%Y年,%m月,%d日")
    append_description (article.content || article.title || '').mb_chars[0..50]
  end

  def seo_for_user(user=@user)
    append_keywords user.name, user.login
    append_description "#{user.name}发表的文章。"
  end

  def render *args
    append_description  "博聆网 一个有人情味的社区 轻论坛"
    append_keywords "bling, 博聆网, 人情味, 社区, 轻论坛"
    super
  end

  def self.included(base)
    base.class_eval do
      helper_method :keywords, :description
    end
  end
end
