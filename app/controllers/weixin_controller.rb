require 'weixin/model'
class WeixinController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :check_lock_post
  before_filter :check_weixin_legality
  after_filter :save_weixin_user
  respond_to :xml
  TOKEN = "94dj43l3Zus9qh9i73I9dhf028873x"
  API_KEY = ''
  API_SECRET = ''
  API_ENDPOINT = 'https://api.weixin.qq.com/cgi-bin/token'
  def show
    render :text => params[:echostr]
  end

  def create
    meth = "#{@message.MsgType}_handler"
    if respond_to?(meth)
    	render xml: send(meth)
    else
    	render :nothing => true
    end
  end

  # def voice_handler
  #   if @user = @weixin_user.user
  #     mid = @message.MediaId
  #   end
  # end

  def event_handler
    meth = "on_#{@message.MsgType}"
    content = ""
    if respond_to? meth
      content = send meth
    end
    render :nothing => true
    #Weixin.text_msg(@message.ToUserName, @message.FromUserName, content)
  end

  def on_subscribe
  end

  def on_unsubscribe
    @weixin_user.destroy
  end

  def text_handler

    #msg = @message
    @message.Content.strip!
    content = case @message.Content
    when /\A绑定[[:space:]]*(.*)/, /\Abind[[:space:]]*(.*)/
      if @weixin_user.user
        '您已经绑定过账号'
      else
        username = $1
        user = User.find_by_login($1)
        if user
          if user.weixin_user
            if user.weixin_user == @weixin_user
              '您已经绑定过此账号'
            else
              '该账号已经绑定过了，不能进行绑定'
            end
          else
            code = rand(10000..999999)
            Rails.cache.write(['weixin.tobind', @message.FromUserName], username)
            Rails.cache.write(['weixin.verify', username], code)
            Rails.logger.debug("weixin code #{username}, #{code}")
            Message.send_system_message(user, "微信验证码：#{code}")
            '我们已经将验证码发送至您的邮箱还有网站小纸条，请回复其中提到的验证码'
          end
        else
          '没有该用户'
        end
      end
    when /\A\d+\z/
      username = Rails.cache.read(['weixin.tobind', @message.FromUserName])
      user = User.find_by_login(username)
      code = Rails.cache.read(['weixin.verify', username])
      if code.to_s == @message.Content
        @weixin_user.user = user
        @weixin_user.save
        '绑定成功'
      else
        '绑定失败'
      end
    when 'whoami'
      if @weixin_user.user
        "您已绑定#{@weixin_user.user.name}(#{@weixin_user.user.login})"
      else
        '请绑定账号获得更多功能'
      end
    when '积分'
      if @weixin_user.user
        "您的账号中有#{@weixin_user.user.credit}积分"
      else
        '请绑定账号获得更多功能'
      end
    when '热点'
      @items = Inbox.guest.hottest.page(1).per(5).all
      @articles = @items.collect{|i|i.article}
      @articles.reject!do |art|
        art.nil? or art.top_post.nil? or (logged_in? and (current_user.disliked?(art.user) or current_user.disliked?(art.group)))
      end
      @articles.collect{|art| "#{art.article_title} #{article_url(art.group, art, :host => 'm.bling0.com')}"}.join("\n")
    when '最新'
      gids = Group.not_show_in_list.collect{|g|g.id}
      scope = Article.unscoped.where(:status => 'publish').where("articles.group_id not in (?)", gids)
      scope = scope.order('articles.created_at desc').where('articles.created_at < NOW()')
      @articles = scope.page(1).per(5)
      @articles.collect{|art| "#{art.article_title} #{article_url(art.group, art, :host => 'm.bling0.com')}"}.join("\n")

    when /晚安|goodnight/i
      @weixin_user.session['goodnight_id'] ||= 0
      group = Group.wrap('goodnight')
      article = group.public_articles.where('id > ?', @weixin_user.session['goodnight_id']).order('id asc').first
      if article
        @weixin_user.session['goodnight_id']= article.id
      else
        @weixin_user.session['goodnight_id']= 0
        article = group.public_articles.first
      end

      "#{article.title}#{article.content} - by #{article.user.name}"
    else
      '发送“热点”、“最新”查询相应文章，请绑定账号获得更多功能'
    end
    Weixin.text_msg(@message.ToUserName, @message.FromUserName, content)
  end

  def bind

  end

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = [TOKEN, params[:timestamp], params[:nonce]].sort
    return render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
    hash = params[:xml]
    m = "Weixin::#{hash[:MsgType].classify}Message".safe_constantize
    @message = m.new(hash)
    @weixin_user = Weixin::User.find_or_create_by(uid: @message.FromUserName)

    Rails.logger.debug(@message.inspect)
    logger.debug(@weixin_user.inspect)
  end

  def access_token
    @access_token ||= Rails.cache.fetch('weixin.access_token') do
      RestClient.get API_ENDPOINT, {grant_type: 'client_credential' }
    end
  end

  def save_weixin_user
    logger.debug(@weixin_user.changed.inspect)
    @weixin_user.save if @weixin_user.changed?
  end
end
