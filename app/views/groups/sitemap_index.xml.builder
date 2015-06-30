xml.instruct!

xml.sitemapindex 'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @groups.each do |group|
    if group.topics.count > 0
      xml.sitemap do
        xml.loc sitemap_topics_url(group, :format => :xml)
        xml.lastmod group.topics.maximum(:created_at).xmlschema
      end
    end
  end
end
