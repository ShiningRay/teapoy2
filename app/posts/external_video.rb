require 'net/http'
require 'uri'
require 'open-uri'
require 'iconv' unless String.method_defined?(:encode)
class ExternalVideo < Post
  field :video_page_link
  field :video_flash_link
  field :thumb_img_link
  field :video_title
  field :duration, type: Integer
  field :thumb_img_link, type: String, default: "/images/playvideo.jpg"

  VideoPageLinkPattern = {
    youku: /v.youku.com/,
    tudou_program: /www.tudou.com\/programs\/view\/([a-zA-Z0-9_-]+)\/?/,
    tudou_playlist: /www.tudou.com\/playlist\/p\/l(\d+)(?:i(\d+))?\.html/,
    yinyuetai: /www.yinyuetai.com/,
    ku6: /ku6.com/,
    com56album: /56.com\/w\d+\/play_album-aid-\d+_vid-(\w+?)\.html/,
    com56single: /56.com\/u\d+\/v_(\w+?).html/,
    mysohu:/my.tv.sohu.com/,
    sohu: /tv.sohu.com/,
    baomihua_sohu: /baomihua.tv.sohu.com\/play/,
    baomihua:/video.baomihua.com|p.pomoho.com/,
    sina: /video.sina.com.cn/,
    sina_tv: /tv.video.sina.com.cn/,
    sina_movie: /video.sina.com.cn\/m/,
    ifeng:/v.ifeng.com/,
    qq: /v.qq.com/,
    iqiyi:/iqiyi.com/
  }
  VideoFlashLinkPattern = {
    youku: /player.youku.com/,
    tudou: /www.tudou.com\/v\//,
    yinyuetai: /www.yinyuetai.com\/video/,
    sina: /www.video.sina.com.cn/
  }
  #validates :video_page_link, :video_flash_link, :thumb_img_link,
  #          format: {with: /\A(http|https):\/\/[a-z0-9]+([-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/ix, on: :create}
  before_create :fetch
  #protected
  def fetch
    #response = HTTParty.get video_page_link
    case video_page_link.gsub(/^http:\/\/|^https:\/\//,"")
    when VideoPageLinkPattern[:youku]
      doc = Nokogiri::HTML(open(video_page_link))
      link = doc.css('#link2').first
      self.video_flash_link = link['value']
      sina = doc.css("#s_msn1").first
      uri = URI.parse sina['href']
      query =  CGI.parse(uri.query)
      self.thumb_img_link = query['screenshot'].first
      self.video_title = query['Title'] || doc.title
    when VideoPageLinkPattern[:tudou_program]
      tid = $1
      self.video_flash_link = "http://www.tudou.com/v/#{tid}/&autoPlay=true/v.swf"
      content = open(video_page_link).read
      content = Iconv.conv('utf-8//IGNORE', 'gbk', content) if RUBY_VERSION < '1.9'
      if content =~ /<title>(.*?)<\/title>/
        self.video_title = $1
      end

      if content =~ /pic\s*=\s*'(.*?)'/
        self.thumb_img_link = $1
      end
    when VideoPageLinkPattern[:tudou_playlist]
      lid = $1
      iid = $2
      content = open(video_page_link).read
      content = Iconv.conv('utf-8//IGNORE', 'gbk', content) if RUBY_VERSION < '1.9'
      unless iid
        if content =~ /defaultIid\s*=\s*(\d+)/
          iid = $1
        end
      end
      #logger.debug(iid)
      if content=~ /iid:#{iid}[^}]*/
        #logger.debug($&)
        info = $&.gsub(/(^|,)\s*(\w+):/){|m| "#$1\"#$2\":"}.gsub(/parseInt\(([^\)]*)\)/, '\1')
        #logger.debug("{#{info}}")
        info = ActiveSupport::JSON.decode("{#{info}}")
        self.video_title = info['title']
        self.thumb_img_link = info['pic']
        self.video_flash_link = "http://www.tudou.com/l/#{info['icode']}/&iid=#{iid}&autoPlay=true/v.swf"
      end
      #<embed src="http://www.tudou.com/l/HBtyAxsL3KI/&iid=98874484/v.swf" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" wmode="opaque" width="480" height="400"></embed>
      #doc = Nokogiri::HTML(open(video_page_link))
      #msn = doc.css('a[title="分享到MSN"]').first
      #sources  = CGI.parse(msn['href'])
      #self.video_title = sources["title"].first
      #self.thumb_img_link = sources["screenshot"].first
      #self.video_flash_link = CGI.parse(doc.css('a[title="分享到天涯"]').first['href'])["strFlashURL"].first
     when VideoPageLinkPattern[:yinyuetai]
      doc = Nokogiri::HTML(open(video_page_link))
      link = doc.css('meta[property="og:videosrc"]').first
      self.video_flash_link  =  link['content']
      self.video_title =  doc.css('meta[property="og:title"]').first['content']
      sina = doc.css('meta[property="og:image"]').first
      self.thumb_img_link = sina['content']

    when VideoPageLinkPattern[:ku6]
      content = open(video_page_link).read
      if content =~ /^App\s*=\s*(.*);\s*$/
        app = ActiveSupport::JSON.decode(`node -e 'console.log(JSON.stringify(#$1))'`)
        info = app['VideoInfo']
        Rails.logger.debug(info.inspect)
        self.video_flash_link = "http://player.ku6.com/refer/#{info['id']}/v.swf"
        self.thumb_img_link = info['cover']
        self.article.title ||= self.video_title = info['title']
        self['video_description'] = info['desc']
      end
    when VideoPageLinkPattern[:com56album]
      vid = $1
      content = open(video_page_link).read
      self.video_flash_link = "http://player.56.com/v_#{vid}.swf"
      if content =~ /f_js_playObject\('(.*?)'\);<\/script>/
#=begin
        c = $1.split(/&/)

        p = {}
        c.each do |i|
          name, _, value = i.partition('=')
          p[name] = value
        end
#=end
        logger.debug(p.inspect)
        #p = CGI.parse($1)
        self.thumb_img_link = "http://img.#{p['img_host']}/images/#{p['pURL']}/#{p['sURL']}/#{p['user']}i56olo56i56.com_#{p['URLid']}.jpg"
        self.video_title = p['tit']
        self['normal_flv_url'] = p['normal_flv']
        self['hd_flv_url'] = p['clear_flv']
      end
    when VideoPageLinkPattern[:com56single]
      vid = $1
      content = open(video_page_link).read
      self.video_flash_link = "http://player.56.com/v_#{vid}.swf"
      if content =~ /var\s*_oFlv_o\s*=\s*(.*);$/
        logger.debug($1)
        info = ActiveSupport::JSON.decode($1)
        self.thumb_img_link = "http://#{info['img_host']}/images/#{info['URL_pURL']}/#{info['URL_sURL']}/#{info['user_id']}i56olo56i56.com_#{info['URL_URLid']}.jpg"
      end
      if content =~ /var\s*_oFlv_c\s*=\s*(.*);$/
        logger.debug($1)
        info = ActiveSupport::JSON.decode($1)
        self.video_title = info['Subject']
        #self.video_description = info['Content']
      end
     when VideoPageLinkPattern[:baomihua_sohu]
       doc = Nokogiri::HTML(open(video_page_link))
       self.video_flash_link =  doc.css("param[name='movie']").first['value']
       self.video_title =  doc.title
       return
     when VideoPageLinkPattern[:mysohu]
       content = open(video_page_link).read
       if content =~  /var\s*vid\s*=\s*(.*?);?$/
         self.video_flash_link = "http://share.vrs.sohu.com/my/v.swf&topBar=1&id=#{$1.delete(';').delete('"').delete('\'').to_i}&autoplay=false"
       end
       if content =~  /sCover\s*:\s*(.*?)?$/
         self.thumb_img_link = $1.delete(';').delete('"').delete('\'')
       end
       self.video_title =  Nokogiri::HTML(open(video_page_link)).title
    when VideoPageLinkPattern[:sohu]
       content = open(video_page_link).read
       if content =~  /var\s*vid\s*=\s*(.*?);?$/
         self.video_flash_link = "http://share.vrs.sohu.com/#{$1.delete(';').delete('"').delete('\'')}/v.swf&autoplay=false"
       end

       if content =~  /var\s*cover\s*=\s*(.*?);?$/
         self.thumb_img_link = $1.delete(';').delete('"')
       end
       self.video_title =  Nokogiri::HTML(open(video_page_link)).title

    when VideoPageLinkPattern[:baomihua]
      content = open(video_page_link).read
      if content =~ /fo\.addVariable\(\"flvid\",\s\"(\d+)\"\);/
        self.video_flash_link = "http://resources.pomoho.com/#{$1}.swf"
      end
      self.video_title = Nokogiri::HTML(open(video_page_link)).title
     when VideoPageLinkPattern[:sina_movie]
      content = open(video_page_link).read
      self.video_title      = Nokogiri::HTML(open(video_page_link)).title
      if content =~ /pic:(.*?)\,?$/
          self.thumb_img_link   = $1.gsub(/\'|\,/,"")
      end
      if content =~ /vid:(.*?)\,?$/
         vid =  $1.gsub(/\'|\,/,"").split("|")[0]
          self.video_flash_link ="http://you.video.sina.com.cn/api/sinawebApi/outplayrefer.php/vid=#{vid}_/s.swf"
      end
      return
    when VideoPageLinkPattern[:sina_tv]
      content = open(video_page_link).read
      self.video_title = Nokogiri::HTML(open(video_page_link)).title
      if content =~ /vid:(.*?)\,?$/
       vid =  $1.gsub(/\'|\,/,"").split("|")[0]
       self.video_flash_link ="http://you.video.sina.com.cn/api/sinawebApi/outplayrefer.php/vid=#{vid}_/s.swf"
      end
      return
    when VideoPageLinkPattern[:sina]
      content = open(video_page_link).read
      if content.=~ /title:(.*?)\,?$/
         self.video_title  = $1.gsub(/\'|\,/,"")
      end
      if content =~ /pic:(.*?)\,?$/
        self.thumb_img_link   = $1.gsub(/\'|\,/,"")
      end
      if content=~/swfOutsideUrl:(.*?)\,?$/
        self.video_flash_link = $1.gsub(/\'|\,/,"")
      end
    when VideoPageLinkPattern[:ifeng]
      content = open(video_page_link).read
      if content =~ /var\s*videoinfo\s*=\s*(.*?);?$/
         info = ActiveSupport::JSON.decode($1.delete(";"))
         self.video_title = info["name"]
         self.video_flash_link ="http://v.ifeng.com/include/exterior.swf?AutoPlay=true&guid=#{info["id"]}"
         self.thumb_img_link = info["img"]
      end
    when VideoPageLinkPattern[:qq]
      content = open(video_page_link).read
      if content =~ /vid\s*:\s*"(.*?)",?$/
        self.video_flash_link ="http://imgcache.qq.com/tencentvideo_v1/player/TencentPlayer.swf?_v=20110829&vid=#{$1}&autoplay=1"
      end
      self.video_title  = Nokogiri::HTML(open(video_page_link)).title
      if content =~ /coverPic\s*:\s*"(.*?)",?$/
         self.thumb_img_link   = $1
      end
    when VideoPageLinkPattern[:iqiyi]
      content = open(video_page_link).read
      flashurl = "http://www.qiyi.com/player/20120316100139/qiyi_player.swf"
      if content =~ /\stitle\s:\s(.*?)?$/
        self.video_title = $1.split(",")[0].delete("\"")
      end
      if content =~ /\svideoId\s:\s(.*?)?$/
        self.video_flash_link = flashurl+"?vid="+$1.split(",")[0].delete("\"")
      end
    end
  end
end
