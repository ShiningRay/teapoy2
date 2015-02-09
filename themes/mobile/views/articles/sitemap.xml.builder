xml.instruct!
#xml.instruct!('xml-stylesheet', :type => "text/xsl", :href =>"/stylesheets/rsspretty.xsl")
ns = {'xmlns' => "http://www.sitemaps.org/schemas/sitemap/0.9"}
ns['xmlns:mobile']="http://www.google.com/schemas/sitemap-mobile/1.0" unless cookies[:mobile_view].blank?
xml.urlset ns do
  @articles.each do |article|
    xml.url do
      xml.loc article_url(@group, article)
      xml.lastmod article.updated_at.xmlschema
      xml.changefreq article.closed? ? 'never' : 'always'
      xml.priority [0, article.top_post.try(:score).to_i / @max_score].max
      xml.mobile :mobile unless cookies[:mobile_view].blank?
    end
  end
end

