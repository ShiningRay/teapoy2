# -*- encoding: utf-8 -*-
module TopicsHelper
  def navigator

  end

  def embed_topic(group_id, topic_slug)
    cache [group_id, topic_slug, :content] do
      group = Group.wrap group_id
      topic = group.topics.wrap topic_slug
      topic.content
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

  def topic_title(topic=@topic, max_len=20)
    topic.topic_title(max_len)
  end

  def topic_page?
    controller_name == 'topics' and action_name == 'show'
  end

  def topic_author(topic=@topic)
    user = topic.user
    if user.id != 0 && !topic.anonymous
      user.name_or_login
    else
      '匿名人士'
    end
  end

  def topic_owenr_class(topic=@topic)
    @list_view || topic.anonymous ? '' : 'topic-owner'
  end

  def show_tags(topic, current_tag = nil)
    tag = topic.tag_line
    return if tag.blank?
    m = {}
    r = topic.tags.collect do |t|
      t = t.name
      l = link_to t, {:controller => :groups, :action => :tag, :id => topic.group.id, :tag => t}, {:rel => 'tag'}
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
