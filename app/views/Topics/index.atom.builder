atom_feed(:schema_date => topics.first.created_at) do |feed|
  feed.title("#{@group.name}")

  feed.updated(topics.first.created_at)

  topics.each do |topic|
    feed.entry(topic, :url => topic_url(@group, topic)) do |entry|
      entry.title(topic_title topic)
      p = topic.top_post
      c = ''
      unless p.blank?
        c = p.is_a?(Picture) ? "http://#{request.host_with_port}#{p.picture.large.url}" : ''

        unless p.content.blank?
          c << p.content
        end
      end
      entry.content(c, :type => 'html')

      entry.author do |author|
        if topic.anonymous
          author.name('Anonymous user')
        else
          author.name(topic.user.login)
        end
      end
    end
  end
end
