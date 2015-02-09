atom_feed(:schema_date => @articles.first.created_at) do |feed|
  feed.title("#{@group.name}")

  feed.updated(@articles.first.created_at)

  @articles.each do |article|
    feed.entry(article, :url => article_url(@group, article)) do |entry|
      entry.title(article_title article)
      p = article.top_post
      c = ''
      unless p.blank?
        c = p.is_a?(Picture) ? "http://#{request.host_with_port}#{p.picture.url(:large)}" : ''

        unless p.content.blank?
          c << p.content
        end
      end
      entry.content(c, :type => 'html')

      entry.author do |author|
        if article.anonymous
          author.name('Anonymous user')
        else
          author.name(article.user.login)
        end
      end
    end
  end
end
