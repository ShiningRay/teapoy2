xml.instruct!
#xml.instruct!('xml-stylesheet', :type => "text/xsl", :href =>"/stylesheets/rsspretty.xsl")
ns = {'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9"}
ns['xmlns:mobile']="http://www.google.com/schemas/sitemap-mobile/1.0" unless cookies[:mobile_view].blank?
xml.urlset ns do
  topics.each do |topic|
    xml.url do
      xml.loc topic_url(@group, topic)
      xml.lastmod topic.updated_at.xmlschema
      xml.changefreq topic.closed? ? 'never' : 'always'
      xml.priority [0, topic.top_post.try(:score).to_i / @max_score].max
      xml.mobile :mobile unless cookies[:mobile_view].blank?
    end
  end
end

