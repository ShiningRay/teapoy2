# coding: utf-8
#require ''
require 'open-uri'
module Importer
class Qiushibaike
  @@base_time = Time.now
  cattr_accessor :base_time

  def self.import
    import_page('http://www.qiushibaike.com/')
    #import_page('http://www.qiushibaike.com/')
  end

  def self.init_db
    db = LevelDB::DB.new File.join(Rails.root, 'db', 'uri.db')
    ExternalPage.find_each do |p|
      db.put p.source_link, p.article_id.to_s
    end
  end
  def self.import_old
    (1..2205).reverse_each do |i|
      url = "http://www.qiushibaike.com/new2/late/20/page/#{i}?slow"
        puts url
      5.times do
        begin
          import_page(url)
          break
	rescue Timeout::Error
        puts 'retrying...'
          sleep 10
          retry
        rescue => e
        puts e
puts e.backtrace
        puts 'retrying...'
          sleep 10
          retry
        end
      end
      sleep 10
    end
  end
  def self.import_page(page)
    doc = Nokogiri::HTML open(page, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)')

    doc.css('.block').each do |div|
      puts "===================================="
      id = div['id'].gsub('qiushi_tag_', '')
      puts id
      url = "http://www.qiushibaike.com/article/#{id}"
      puts url
      if ExternalPage.url_exists?(url)
        puts 'exists skip'
        next
      end
      time = Time.parse div.css('.content').first['title']
      #pos_score = div.css('.up').first.content.to_i
      #neg_score = div.css('.down').first.content.to_i.abs

      #if pos_score - neg_score < 10
      #  puts "low quality skip"
      #  next
      #end

      content = div.css('.content').first.content
      author = div.css('.author')

      #if author.size > 0
      #  author_name = author.first.content.strip
      #  content = "#{content}\nBY: #{author_name}"
      #end

      tags = div.css('.tags')
      #title="糗事\##{id}"

      if tags.size > 0
        tag_line = tags.first.content
        #title = "#{title} #{tag_line}"
      end

      pic = div.css('.thumb')

      if pic.size > 0
        next #just ignore picture now
        img = pic.css('img').first['src']
        #img.gsub!(/picbak/, 'pictures')
        #img.gsub!(/medium/, 'original')
        puts img
        filename = File.basename(img)
        filename = File.join('/tmp', filename)
        begin
        open(img, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)') {|f|
           File.open(filename,"wb") do |file|
             file.puts f.read
           end
        }
        rescue Timeout::Error
          next
        rescue => e
          next
        end

        puts filename
        content = "#{content} \n via: #{url}"
        post = Picture.new(:content => content, :user_id => 0, :anonymous => 1)
        post.picture = File.open(filename)

      else
        post = ExternalPage.new(:content => content, :source_link => url, :source_site => '糗事百科', :user_id => 0, :anonymous => 1)
        post.content = content
      end
      #post.pos = pos_score / 10
      #post.neg = neg_score / 10
      post.pos = 0
      post.neg = 0
      post.score = 0
      post.floor = 0
      post.group_id = 2
      post.user_id = 0
      #post.score = #pos_score-neg_score
      article = Article.new :anonymous => 1, :group_id => 2
      article.user_id = 0
      article.status = 'publish'
      article.top_post = post
      #post.created_at = base_time
      #article.created_at = base_time
      unless article.save
        puts article.errors.full_messages.join("\n")
      end
      #self.base_time += 300
    end
  end
end
end
