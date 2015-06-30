# coding: utf-8
xml.instruct!
xml.instruct!('xml-stylesheet', :type => "text/xsl", :href =>"/stylesheets/rsspretty.xsl")

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    #@options[:pubDate] = @items.any? ? @items.first[:pubDate] : Time.now if not @options.include?(:pubDate)
    xml.atom :link, :href => group_articles_url(@group||'all', :xml), :rel => 'self', :type => 'application/rss+xml'
    if @group
      xml.title       @group.name
      xml.link        group_articles_url(@group)
    else
      xml.title       ENV['SITE_NAME']
      xml.link        root_url
    end
    xml.pubDate     topics.first.try(:created_at).try(:rfc2822)
    xml.description @group.try(:description)

    topics.each do |article|
      xml.item do
        xml.title       article_title article
        xml.link        article_url(article.group, article)
        xml.description render(:partial => 'articles/topic', :formats => [:html], :object => article)
        xml.pubDate     article.created_at.rfc2822
        xml.guid        article_url(article.group, article)
        #xml.author      topic.user.login
      end
    end
  end
end

