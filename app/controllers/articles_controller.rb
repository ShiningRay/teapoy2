# -*- coding: utf-8 -*-
class ArticlesController < ApplicationController
  before_action :find_group
  before_action :find_user, if: -> { params[:user_id].present? }
  before_action :find_article, only: %i(show edit update destroy unpublish links mark)

  rescue_from User::NotAuthorized ,with: :group_is_secret
  # check_duplicate 'article/content', only: :create
  rescue_from  ActiveRecord::RecordNotFound, with: :show_404
  rescue_from Mongoid::Errors::DocumentNotFound, with: :show_404
  around_filter only: [:edit, :create] do |controller, action|
    Article.unscoped do
      action.call
    end
  end
  #load_and_authorize_resource :group
  #load_and_authorize_resource :article, through: :group
  # cache_sweeper :article_sweeper
  #before_filter :oauthenticate, only: [:create]
  #after_filter :store_location, only: [:index, :show, :new]
  # before_filter :login_required, except: [:index, :recent_hot, :show, :sitemap, :scores, :feed, :new, :create]

  # caches_action :sitemap, expires_in: 1.day
  # caches_action :feed, expires_in: 1.day
  KEYS = %w(day week month year all)

  DateRanges = {
    '8hr' => 8.hour,
    'day' => 1.day,
    'week' => 1.week,
    'month' => 1.month,
    'year' => 1.year
  }

  #before_filter :date_range_detect, only: [:hottest, :most_replied]
  #respond_to :html, :json, except: :digest
  #respond_to :atom, only: :index
  has_scope :order, only: :index
  has_scope :limit, only: :index

  caches_page_for_anonymous :index, :show, :recent_hot

  def pending
    find_group
    return render text: "只有小组长才可以审帖" unless current_user.own_group?(@group)
    @articles = @group.pending_articles.includes(:top_post).page(params[:page])
    respond_with @articles
  end


  # :scope/:order/:filter
  # scope:
  #   group_id: all/articles stands for all
  #   tag_id
  # order:
  #   latest, day, week, month, year, trending
  # filter
  # page
  def index
    if params[:group_id]
      if params[:group_id] == 'all' or params[:group_id] == 'articles' and @group.blank?
        gids = Group.not_show_in_list.collect{|g|g.id}
        scope = Article.unscoped.where(status: 'publish').where(:group_id.nin => gids)
      else
        find_group
        return render text: '', status: :not_found unless @group
        raise User::NotAuthorized if @group and @group.private and (not logged_in? or !current_user.is_member_of?(@group))
        return render template:"/groups/pending" if @group.status == "pending"
        scope = @group.public_articles.where(status: 'publish')
      end
    end

    #scope = scope.public_articles.where('articles.created_at <= ?', Time.now)
    params[:limit] ||= 'day' if params[:order] == 'hottest'

    if i = KEYS.index(params[:limit])
      params[:order] = 'hottest'
      @limit = params[:limit]
      @next_limit = KEYS[i+1]
      scope = scope.hottest
      if @limit != 'all' and l = DateRanges[@limit]
        pre = l.to_i / 360
        ago = l.ago.to_i
        @expires_in = pre
        ago -= ago % pre
        scope = scope.where(:created_at.gt => Time.at(ago))
      end
    elsif params[:order] == "latest_comment"
      @order = "latest_comment"
      scope = scope.latest_updated
    else
      params[:order] = 'latest'
      scope = scope.latest_created
    end

    if params[:after]
      scope = scope.where(:id.gt => params[:id]).sort(id: -1)
    end

    if params[:before]
      scope = scope.where(:id.lt => params[:id]).sort(id: 1)
    end

    @articles = scope.includes(:top_post, :posts, :group).page(params[:page])
    @show_group = !@group
    @list_view = true
    if logged_in?
      @top_posts = @articles.collect{|a|a.top_post}
#### below is some code for performance considerations, preloading some
#### related records. But for current low traffic, we don't need them
=begin
      @rated = current_user.has_rated?(@top_posts)
      @rated = current_user.ratings_for(@top_posts)
      ### preload subscriptions for articles and users
      current_user.preload_subscribed(@articles)
      ### reject blocked articles
      @articles.reject! do |art|
        current_user.disliked?(art.user) or current_user.disliked?(art.group)
      end
      current_user.preload_subscribed(@articles.collect{|a|a.user})
=end
    end
    # @articles.reject!{|a| a.top_post.nil? or a.top_post.status == 'deleted' }
    if stale?(@articles)
      respond_to do |format|
        format.html
        format.json do
          render json: @articles, callback: params[:callback]
        end
### we don't need rss output now.
        # format.xml {
        #   prepend_view_path File.join(Rails.root, 'app', 'views', 'feeds')
        #   render text: '<?xml version="1.0" encoding="UTF-8"?><rss></rss>', status: :not_found if @articles.empty?
        # }
        format.wml
      end
    end
  end

  def recent_hot
    return redirect_to group_path(@group) if @group
    @list_view = true
    @show_group = true
    @items = Inbox.guest.hottest.page(params[:page]).all
    @articles = @items.collect{|i|i.article}
    @articles.reject! do |art|
      art.nil? or art.top_post.nil? or (logged_in? and (current_user.disliked?(art.user) or current_user.disliked?(art.group)))
    end
    @items.replace(@articles)

    respond_to do |format|
      format.any(:html, :mobile, :wml)
      format.json do
        render json: {
          articles: @articles,
          num_pages: @items.num_pages
        }
      end
    end
  end

  def sitemap
    expires_in 1.hour, public: true
    @group = Group.wrap! params[:group_id]
    @max_score = [@group.public_articles.maximum('score').to_i, 1].max
    @articles = @group.public_articles.before
    if stale?(etag: @articles, last_modified: @articles.first.try(:created_at), public: true)
      respond_to do |format|
        format.xml
      end
    end
  end

  def new
    #find_group
    return login_required unless logged_in? or (@group && @group.preferred_guest_can_post?)
    return render template:"/groups/pending" if @group && @group.status == "pending"
    @article = Article.new
    @article.top_post = Post.new
    # @article.attachments = [Post.new]
    @article.title = params[:title]
    @article.status = 'publish'
    @article.group_id ||= 1
    @article.top_post.group_id ||= 1

    unless params[:featured].blank?
      art =  @group.articles.featured.find_by_title params[:title]
      if art
        return redirect_to(article_path(@group, art))
      end
      @article.status = 'feature'
    end
  end

  def unpublish
    resource.status = 'private'
    resource.save!
    respond_to do |format|
      format.any(:html, :mobile, :wml) {
        flash[:notice] = 'unpublished'
        redirect_to edit_article_path(resource.group, resource)
      }
    end
  end

  def create
    if params[:group_id] and params[:group_id] != 'all'
      @group = Group.find_by_alias! params[:group_id]
    else
      @group = Group.find(params[:article][:group_id] || 1)
    end
    return login_required unless logged_in? or @group.preferred_guest_can_post?
    error_return = Proc.new do |msg|
      respond_to do |format|
        format.any(:html, :wml) {
          if request.xhr?
            render text: msg
          else
            flash[:error] = msg
            render :new
          end
        }
        format.json{
          render json: {error: msg}, status: :unprocessable_entity
        }
        format.js {
          @message = msg
          render 'create_failed'
        }
      end
      return
    end
    article = article_params

    if request.post? and article # it is a request and has params, a good request.
      #article[:content] = ActionController::Base.helpers.sanitize article[:content]
      article[:content].strip! if article.include?(:content) # trim the white space in the end or beginning
      article[:title].strip! if article.include?(:title)
      article[:anonymous] = false if article[:anonymous].blank?
      article[:uncommentable] = false if article[:uncommentable].blank?
      article.delete :title if article[:title].blank?
      #article[:ip] = request.remote_ip
      #article.delete(:picture) unless logged_in?
      article[:top_post_attributes] ||= {}
      top_post = article[:top_post_attributes]
      top_post[:content].strip! if top_post.include?(:content)
      status = article.delete(:status)
      # for mobile devices simple form
      if p = article.delete(:picture)
        if !p.blank? and top_post[:type].blank? or top_post[:type] == 'Post'
          top_post[:type] = 'Picture'
          top_post[:picture] = p
          transform_binary(top_post, :picture)
          top_post.delete :video_page_link
        end
      end

      if vl = article.delete(:video_page_link)
        vl.strip!
        if !vl.blank? and (top_post[:type].blank? or top_post[:type] == 'Post')
          top_post[:type] = 'ExternalVideo'
          top_post[:video_page_link] = vl
        end
      end

      if fl = article.delete(:swf)
        if !fl.blank? and (top_post[:type].blank? or top_post[:type] == 'Post')
          top_post[:type] = 'Flash'
          top_post[:swf] = fl
        end
      end
      top_post.delete(:question_content)  if top_post[:question_content].blank?
      if c = article.delete(:content)
        top_post[:content] = c if top_post[:content].blank?
      end
      if (top_post[:type].blank? || top_post[:type] == 'Post')
        if !article[:title].blank? and top_post[:content].blank?
          top_post[:content] = article.delete(:title)
        end
        k = top_post.keys.collect{|i|i.to_s} - ['content']
        k.each {|k1| top_post.delete(k1)}
      end
      article[:top_post_attributes].permit!
      begin
        @article = Article.new( article )
      rescue ActiveRecord::UnknownAttributeError
        @article = Article.new
        @article.top_post = Post.new
        error_return.call('发现不明数据，您是不是选错了文章类型了呢？')
      end
      @post = @article.top_post

      if logged_in?
        @article.user_id = current_user.id
        @post.user_id = current_user.id
        current_user.spend_credit(20, 'anonymous') if @article.anonymous?
      else
        @article.user_id = 0
        @article.anonymous = true
      end

      @article.group_id = @group.id if not @article.group_id or @article.group_id == 0
      @article.group_id = 1 if @article.group_id == 0
      @article.comment_status ||= 'open'
      if !status.blank? and logged_in? and current_user.own_group?( @group) or current_user.is_admin?
        @article.status = status || 'publish'
      else
        @article.status = @group.preferred_articles_need_approval? ? 'pending' : 'publish'


        if @group.options.only_member_can_post and !current_user.is_member_of?(@group)
          error_return.call('只有小组成员才能在这里发贴')
        end
      end
      error_return.call('未激活用户暂时不能发帖') unless current_user.active? or @group.preferred_guest_can_post?

      if @article.save
        current_user.subscribe @article if logged_in?
        respond_to do |format|
          format.any(:html, :wml) {
            if @article.status == 'publish' or @article.status == 'feature'
              redirect_to article_path(@group, @article)
            else
              flash[:notice]= '您的文章正在等待审核'
              redirect_to group_path(@group)
            end
          }
          format.json {
            #render nothing: true, status: :created, location: [@group, @article]
            render json: @article
          }
          format.js
        end
      else
        error_return.call(@article.errors.full_messages)
      end
    else #it is a bad request.
      flash[:notice]= "文章发表失败"
      error_return.call(flash[:notice])
    end
  rescue Balance::InsufficientFunds
    flash[:notice] = "余额不足，不能发表文章"
    error_return.call(flash[:notice])
  end

  def feed
    prepend_view_path File.join(Rails.root, 'app', 'views', 'feeds')
    #params[:format] = :xml
    @group = Group.find_by_alias params[:group_id]
    return show_404 unless @group
    @articles = @group.public_articles.latest.before.includes(:top_post).page(params[:page])
    @articles.reject!{|a| a.top_post.nil? }
    #render template: 'articles/index'
    if @articles.size == 0
      render text: '<?xml version="1.0" encoding="UTF-8"?><rss></rss>', status: :not_found if @articles.empty?
    else
      render :index
    end
  end

  # Please Refer to ScoreMetal
  def scores
    ids = params[:ids].split(/ |\+/).collect{|i|i.to_i}
    s = Article.find_all_by_id(ids)
    s.reject!{|a|a.top_post.blank?}
    if logged_in?
      rated = current_user.ratings_for(ids)
      watched = current_user.subscribed_for?(ids)
      read = current_user.has_read?(ids)
      response.headers['Cache-Control'] = 'private'
    else
      response.headers['Cache-Control'] = 'public'
    end

    m = {}
    s.each do |r|
      id = r.id
      json = r.as_json

      if logged_in?
        json['rated'] = rated[id].to_i
        json['subscribed'] = !!watched[['Article', id]]
        json['read_to'] = read[id]
      end
      m[id] = json
    end

    respond_to do |format|
      format.json {
        render json: m
      }
    end
  end

  def update
    return head :access_denied unless current_user.is_admin? or current_user == resource.user or current_user.own_group?(resource.group)
    resource.operator = current_user.id
    update!
  end

  def search
    @list_view = true
    @term = params[:term] || ""
    @term.strip!
    if params[:group_id] and params[:group_id] != 'all' and params[:group_id] != 'articles'
      @group = Group.find_by_alias params[:group_id]
      collection = @group.articles
    else
      collection = Article
    end

    if @term.size > 1
      t= Regexp.new @term
      @articles = collection.public_articles.where(:title => t).page(params[:page])
    else
      redirect_to articles_path(@group)
    end
    #render action: :index
  end

  def show
    if params[:group_id] == 'articles'
      @article = Article.wrap! params[:id]
      @group = @article.group unless @group
      return redirect_to article_path(@group, @article, format: params[:format]) unless request.format == :json
    end
    @show_article = true
    @list_view = false
    @show_group = true

    authorize @article
    @group = @article.group unless @group
    # seo_for_article
    # expires_now if browser.opera?
    if stale?(@article)
      respond_to do |format|
        format.html {
          render @article if request.xhr? and theme_name != 'jquerymobile'
        }
        format.json {
          render json: @article
        }
      end
    end
    MarkingReadWorker.perform_async(current_user.id, @article.id, @article.comments.size-1) if logged_in? and not request.xhr?
  end

  def mark
    MarkingReadWorker.perform_async(current_user.id, @article.id) if logged_in?
    Inbox.where(user_id: current_user.id, article_id: @article.id).first.try(:read!)
    respond_to do |format|
      format.any(:html, :mobile, :wml) {
        head :ok
      }
      format.json {
        head :ok
      }
    end
  end

  def move
    if current_user.is_admin?
      @group = Group.find_by_alias params[:group_id]
      d = params[:dest_group_id]
      dest_group = (d =~ /\A\d+\z/ ? Group.find(d) : Group.find_by_alias(d))

      @article = @group.articles.wrap! params[:id]
      @article.operator = current_user.id
      @article.move_to(dest_group, (params[:repost] == '1'))
      Message.send_message(current_user.id, @article.user_id, "您的帖子被#{current_user.name_or_login}移到了#{dest_group.name}中。地址是：#{article_url(dest_group,@article)}")
      #@article.score.group_id = params[:group_id]
      #@article.save!
      #@article.score.save!
      if params[:repost] == '1'
        redirect_to article_path(@group, @article)
      else
        redirect_to article_path(dest_group, @article)
      end
    else
      redirect_to :back
    end
  end

  def move_out
    @group = Group.find_by_alias params[:group_id]
    return render text:"没有权限移动帖子" unless (current_user.is_admin? || current_user.own_group?(@group))

    Article.unscoped do
      @article = @group.articles.wrap! params[:id]
    end

    @article.move_out
    Message.send_message(current_user.id, @article.user_id, "您的帖子被#{@group.name}小组的组长移到了水库中。地址是：#{article_url(Group.find(1),@article)}")
    respond_to do |format|
      format.any(:html,:mobile,:wml){
        redirect_to pending_articles_path(@group)
      }
      format.json{
        render json:{}
      }
    end
  end

  def destroy
    @group = @article.group
    if current_user.own_article?(@article) or @group.owner_id == current_user.id or current_user.is_admin?
      @article.destroy
      respond_to do |format|
        format.html {
          if request.xhr?
            render text: '', layout: false
          else
            redirect_to group_articles_path(@group)
          end
        }
        format.any(:mobile, :wml) {
          redirect_to group_articles_path(@group)
        }
        format.js
      end
    else
      flash[:error] = '你没有权限删除这篇帖子'
      respond_to do |format|
        format.any(:html,:mobile,:wml){
          redirect_to group_articles_path(@group)
        }
      end
    end
  end

  def subscribe
    raise User::NotAuthorized unless logged_in?
    @group = Group.find_by_alias! params[:group_id]
    @article = @group.articles.wrap params[:id]
    current_user.subscribe @article
    respond_to do |format|
      format.html do
        if request.xhr?
          render @article
        else
          redirect_to article_path(@article.group, @article)
        end
      end
      format.js
    end
  end

  def unsubscribe
    raise User::NotAuthorized unless logged_in?

    @group = Group.wrap params[:group_id]
    @article = @group.articles.wrap params[:id]
    current_user.unsubscribe @article
    respond_to do |format|
      format.html do
        if request.xhr?
          render @article
        else
          redirect_to article_path(@article.group, @article)
        end
      end
      format.js
    end
  end

  # what links here
  def links

  end

  def repost
    # params[:post_id] = params[:post_id].to_i if params[:post_id] =~ /\A\d+\z/
    @post = Post.find params[:post_id]
    return render text: '', status: :not_found unless @post
    @list_view = true

    if request.post?
      @article = Article.new params[:article]
      logger.debug current_user
      if @article.group
        @article = @post.repost_to current_user.id, @article.group_id, false, @article.title
        if @article
          return redirect_to(article_path(@article.group, @article))
        else
        end
      end
    else
      @article = Article.new
      @article.user_id = current_user.id

      if @post.article.title?
        if @post.floor > 0
          @article.title = "转自#{@post.user.name_or_login}对#{@post.article.title}的回复"
        else
          @article.title = "转:#{@post.article.title}"
        end
      end
      render layout: false if request.xhr?
    end
  end

  def publish
    @group = Group.wrap(params[:group_id])
    return render text: "对不起，你没有权限修改" if @group.owner_id != current_user.id
    @article = @group.pending_articles.wrap!(params[:id])
    @article.status = "publish"
    @article.operator = current_user.id
    @article.created_at = Time.now
    @article.save!
    respond_to do |format|
      format.any(:html,:wml,:mobile){
       redirect_to pending_articles_path(@group)
      }
      format.json{
        result = {}
        result[:status] =  @article.status
        render json:result
      }
    end
  end

  def dismiss
    @article = Article.wrap! params[:id]
    item = Inbox.by_user(current_user).by_article(@article)
    item.destroy
    current_user.unsubscribe(@article) if current_user.has_subscribed?(@article)
    render text:""
  end
  protected
  #def collection
  #  @articles ||= end_of_association_chain.public.latest.includes(:top_post).page(params[:page])
  #end
  def group_is_secret
    flash[:notice] =  "这个是私秘小组"
    render action: "forbidden", controller: "groups", status: :forbidden
  end
  def find_group group_id=params[:group_id]
    @group = Group.find_by_alias! group_id
    seo_for_group if @group
    begin
      super
    rescue NoMethodError
    end
  end
  private

  def article_params
    params.require(:article).permit(:group_id, :title, :content, {top_post_attributes: [:type, :content, :picture, :image_url]}, :status, :picture, :video_page_link, :swf, :question_content, :uncommentable, :anonymous)
  end

  def find_group
    if params[:group_id] and params[:group_id] != 'all'
      @group = Group.find_by_alias(params[:group_id])
      @scope = @group.public_articles if @group
    end
  end

  def find_user
    @user = User.find_by_login!(params[:user_id])
    @scope = @user.articles
  end

  def scope
    @scope ||= Article
  end


  def find_article
    @article = scope.wrap! params[:id]
  end

  def resource
    @article ||= scope.wrap! params[:id]
  end
end
