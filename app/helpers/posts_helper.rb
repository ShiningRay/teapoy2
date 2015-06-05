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

  # TODO: optimize out the regexp match
  def rated? post
    if logged_in?
      current_user.has_rated? post
    #else
      #cookies['rating_histories'] =~ Regexp.new("\\b" + (article.is_a?(Article)? article.id : article).to_s + "\\b")
    end
  end

  def rating_status(post, liked=nil, disliked=nil, unvoted=nil, disabled=nil, args={})
    args = args.with_indifferent_access
    liked ||= args[:liked] || args[:pos]
    disliked ||= args[:disliked] || args[:neg]
    unvoted ||= args[:unvoted]
    disabled ||= args[:disabled]
    current_user.own?(post) ? disabled : Rating.status_for(current_user.has_rated?(post), liked, disliked, unvoted)
  end

  # X axis: the action user want to take
  # Y axis: the action user has taken
  RATING_MATRIX=[
    ['disliked', 'cannot_dislike', 'like'],   #
    ['dislike',   0,               'like'],
    ['dislike',  'cannot_like',    'liked']]
  # generate correct rating link
  # the rating link has 3 states, has rated, can be rated(not yet rated), cannot be rated(e.g. user's own post)
  # together with 3 score -1(down), 0(not rated), 1(up)
  # use the matrix above to choose correct template to render
  def rating_link(post, action)
    return if post.destroyed?
    #Rails.cache.fetch(cache_key_for_current_user([:ratinglink, $revision, theme_name, request.format.to_sym, action, post])) do
      action_score = Rating.score_for(action)
      opts = {locals: {user: current_user, post: post}}
      rated_score = logged_in? ? current_user.has_rated?(post) : 0

      if logged_in? && current_user.id == post[:user_id]
        rated_score = action_score
        action_score = 0
      end

      opts[:score] = rated_score
      partial = RATING_MATRIX[rated_score.to_i+1][action_score+1] # +1 to adjust for matrix
      Rails.logger.debug("Post #{post.id} using partial #{partial}")
      if partial != 0
        opts[:partial] = "ratings/#{partial}"
        render( opts)
      end
    #end
  end

  def vote_icon(post, voted_prefix, score_prefix, path, extname)
    path = send "#{direction}_post_path", post
    if logged_in?
      if post[:user_id] == current_user.id
        link_to image_tag(disabled_icon), '#'
      else
        r = current_user.has_rated?(post)
        s = r > 0 ? :up : :dn
        if direction == s
          link_to image_tag(voted_icon), path
        else
          link_to image_tag(unvoted_icon), path
        end
      end
    else
      link_to image_tag(unvoted_icon), path
    end
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
      convert_wiki_link(convert_mention(case post.format
            when :plain
              auto_link(simple_format(emojify(h(post.content).to_str)), :urls)
            when :simple
              simple_format(post.content)
            when :markdown
              RDiscount.new(sanitize post.content).to_html.html_safe
            end), @group || post.group)
    end)
  end

  def convert_wiki_link(content, group=@group)
    return if content.blank?
    content = content.to_s.gsub(/\{\{([0-9a-zA-Z_-]+)(\|[^\}]*)?\}\}/) do |match|
      name = $1
      title = $2[1..-1] if $2

      if name =~ /\A\d+\z/
        page = Article.find_by_id(name)
        group = page.group if page
      else
        page = group.articles.find_by_cached_slug(name)
      end
      if page
        link_to (title.blank? ? article_title(page) : title), article_path(group, page)
      else
        match
      end
    end
    group ||= @article.group if @article
    return content unless group
    content.gsub(/\[\[([^\|\]]*)(\|[^\]]*)?\]\]/) do |match|
      name = $1
      title = $2[1..-1] if $2

      page = group.articles.featured.where(title: name).first
      if page
        original_title = article_title(page)
        link_to((title.blank? ? original_title : title), article_path(@group, page), title: original_title)
      else
        link_to((title.blank? ? name : title), search_group_articles_path(@group||'all', term: name), rel: 'nofollow', class: 'missing')
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
    content.gsub /(?::|：)([^\s]+?)(?::|：)/ do |m|
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
