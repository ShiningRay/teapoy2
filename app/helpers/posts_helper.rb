# encoding: utf-8
module PostsHelper
  def render_posts(posts=@posts)
    return nil unless posts
    posts = Array.wrap(posts)
    raw(posts.map do |post|
      Rails.cache.fetch([post, request.format.to_sym, theme_name, controller_name, action_name]) do
        render(partial: "posts/#{post.class.name.underscore}", object: post)
      end.chomp.force_encoding(Encoding::UTF_8)
    end.join).force_encoding(Encoding::UTF_8)
  end

  def render_post_content(post=@post)
    raw(Rails.cache.fetch(['content', request.format.to_sym, theme_name, post]) do
      render(partial: 'posts/post', object: post).force_encoding(Encoding::UTF_8)
    end).force_encoding(Encoding::UTF_8)
  end

  def render_post_with_parents(post=@post)
    Rails.cache.fetch(['quoted_posts', @list_view, request.format.to_sym, theme_name, request.format.to_sym, post]) do
      output = []
      level = 0
      while post
        if post.anonymous?
          output << '??'
        else
          output << link_to( post.user.name_or_login, post.user)
        end
        output << render_posts(post)
        #output << render(partial: 'comments/comment', object: post)
        if post.parent
          level += 1
          output << '<blockquote class="cf">'
          post = post.parent
        else
          break
        end
      end
      output << '</blockquote>' * level
      output.join.html_safe
    end
  end

  def render_post_form(form, post, type=nil)
    render partial: "posts/#{(type || post.class).to_s.underscore}_form", locals: {form: form, post: post}
  end

  def is_mine_class post
    (logged_in? && current_user.own_post?(post) && 'mine') || ''
  end

  def read_status_class post
    if logged_in?
     read_status = current_user.has_read_post?(post)
     case read_status
     when -1
       then "glance"
     when false,nil
       then "unread"
     else "read"
     end
    end
  end

  def post_content(post=@post)
    raw(Rails.cache.fetch([post, :content, request.format.to_s]) do
      convert_mention(case post.format
        when :plain
          auto_link(simple_format(emojify(h(post.content).to_str)), :urls)
        when :simple
          simple_format(post.content)
        when :markdown
          RDiscount.new(sanitize post.content).to_html.html_safe
        end)
    end)
  end

  def convert_wiki_link(content, group=@group)
    return if content.blank?
    content = content.to_s.gsub(/\{\{([0-9a-zA-Z_-]+)(\|[^\}]*)?\}\}/) do |match|
      name = $1
      title = $2[1..-1] if $2

      if name =~ /\A\d+\z/
        page = Topic.find_by_id(name)
        group = page.group if page
      else
        page = group.topics.find_by_cached_slug(name)
      end
      if page
        link_to (title.blank? ? topic_title(page) : title), topic_path(group, page)
      else
        match
      end
    end
    group ||= topic.group if topic
    return content unless group
    content.gsub(/\[\[([^\|\]]*)(\|[^\]]*)?\]\]/) do |match|
      name = $1
      title = $2[1..-1] if $2

      page = group.topics.featured.where(title: name).first
      if page
        original_title = topic_title(page)
        link_to((title.blank? ? original_title : title), topic_path(@group, page), title: original_title)
      else
        link_to((title.blank? ? name : title), search_group_topics_path(@group||'all', term: name), rel: 'nofollow', class: 'missing')
        #link_to match, title: '', rel: 'nofollow'
      end
    end
  end

  def convert_mention(content)
    content && content.to_str.gsub(/@([a-zA-Z0-9_-]+)/) do |match|
      user = User.wrap($1)
      if user
        link_to "@#{user.name}", user_path(user.login), class: 'user', :'data-login' => user.login, target: "_blank"
      else
        match
      end
    end
  end

  def emojify(content)
    content.gsub( /(?::|：)([^\s]+?)(?::|：)/ )do |m|
      emotion_name = $1.downcase
      if !emotion_name.blank? and ApplicationController::EMOJI_NAMES.include?(emotion_name)
        #content_tag :span, class: "emoji #{emotion_name}"
        "<span class='emoji #{emotion_name}'></span>"
      else
        m
      end
    end
  end
end
