# encoding: utf-8
class MyController < ApplicationController
  before_filter :login_required
  #layout :select_layout
  before_filter :cache_control

  def index
    return redirect_to :action => :inbox
    @list_view = true
    @show_group = true
    params[:order] ||= "time"
    group_ids = current_user.publications(Group).collect{|s|s.id}
    # article_ids = current_user.publications(Article).collect{|s|s.publication.id}
    @articles = Article.where(:group_id.in => group_ids).before.public_articles
    if params[:order] == "hot"
      @articles = @articles.hottest.where(:created_at.gt => 24.hours.ago)
    else
      @articles = @articles.latest
    end
    @articles = @articles.page(params[:page]).includes(:top_post, :group)
    @articles.reject!{|a| a.top_post.nil? }
    @groups =  current_user.publications(Group)
    respond_to do |format|
      format.any(:html, :mobile, :wml)
      format.json {
        render :json => {:num_pages => @articles.num_pages, :articles => @articles}
      }
    end
    #redirect_to current_user
  end

  def mark_all_as_read
    Inbox.by_user(current_user).mark_all_as_read
    respond_to do |format|
      format.js
    end
  end

  def reading

  end

  def liked
    @list_view = true
    @show_group = true
    params[:order] ||= 'time'
    @posts = current_user.liked_posts.page(params[:page])
    @liked_posts_count = current_user.ratings.pos.count
  end

  def latest
    @list_view = true
    @show_group = true
    @items = Inbox.unread.by_user(current_user).desc(:created_at)
    @total_count = @items.count

    @current_page = params[:page] ? params[:page].to_i : 1
    @rest_count = @total_count - @current_page*30

    if params[:before]
      begin
        before = (params[:before] =~ /\d+/ ? Time.at(params[:before].to_i) : Time.parse(params[:before]))
        @items = @items.where(:created_at.lt => before)
      rescue
      end
    end

    @items = @items.limit(30)
    @items = @items.offset(30*(@current_page-1)) if @current_page > 1
    @articles =  @items.collect{|i| i.article_id }
    Inbox.delay.bulk_mark_read(current_user.id, @articles)
    @articles = Article.where(:id => @articles).includes(:top_post, :group).all unless @articles.blank?
    @id2article = {}
    @articles = @articles.compact.collect do |art|
      @id2article[art.id] = art
    end
    #current_user.preload_subscribed(@articles)

    respond_to do |format|
      format.any(:html, :mobile, :wml) do
        if request.xhr?
          render :partial => 'my/article', :collection => @articles
        end
      end
      format.json {
        render :json => {:num_pages => 1, :articles => @articles}
      }
    end
  end

  def recent_read

  end

  def inbox
    @list_view = true
    @show_group = true

    unless params[:ids]
      @items = Inbox.unread.by_user(current_user).desc(:score, :created_at)
      @total_count = @items.count
      @current_page = params[:page] ? params[:page].to_i : 1
      @rest_count = @total_count - @current_page*30
      @items = @items.limit(30).offset((@current_page-1)*30) if @current_page > 1
      @item_ids = @items.collect{|i|i.article_id}
      @items = @items[0, 30]
      @item_ids = @item_ids[30..-1]
    else
      ids = params[:ids].map{|i|i.to_i}
      @items = Inbox.by_user(current_user).any_in(:article_id => ids)#.order("field(id, #{ids.join(',')}")
    end

    @articles = @items.collect{|i| i.article_id }
    Inbox.delay.bulk_mark_read(current_user.id, @articles)
    @articles = Article.where(:id => @articles).includes(:top_post, :group) unless @articles.blank?
    @articles.compact!
    #current_user.preload_subscribed(@articles)
    @id2article = {}
    @articles.each do |art|
      @id2article[art.id] = art
    end
    respond_to do |format|
      format.any :html, :mobile, :wml do
        render :partial => 'my/article', :collection => @articles if request.xhr?
      end
      format.json do
        render :json => {:num_pages => 1, :articles => @articles}
      end
    end
    #@articles
  end

  # show all the groups current user subscribed
  def groups
    #@groups = Kaminari.paginate_array(current_user.publications(Group)).page(params[:page])
    @groups = current_user.publications(Group)
    @in_search_page = true
    respond_to do |format|
       format.any(:html, :mobile, :wml) {
      #  render :template=>'groups/index'
      }
      format.json { render :json => @groups }
    end
  end

  def watched
    @all_subscriptions_count = current_user.publications(Article).size
    @updated_subscriptions_count = 0 #current_user.publications(Article).has_updates.size
    @subscriptions = current_user.subscriptions.where(:publication_type => 'Article').page(params[:page])
    #if params[:filter] == 'all'
      #@subscriptions = current_user.subscriptions.by_publication(Article).page(params[:page])
    #else
    #  @subscriptions = current_user.publications(Article).has_updates.page(params[:page])
    #end
    @publications = @subscriptions.collect(&:publication).compact
    @user = current_user
  end

  def friends
    @articles = Article.paginate(:page => params[:page],
      :conditions => {:status => 'publish',
        :anonymous => false,
        :user_id => current_user.friend_ids},
      :order => 'id desc', :include => :score)
  end

  def friends_comments
    @comments = Comment.paginate(:page => params[:page],
      :conditions => {:status => 'publish',
        :anonymous => false,
        :user_id => current_user.friend_ids
      },
      :order => 'id desc')
  end

  def balance
    @balance = current_user.balance
    respond_to do |format|
      format.js {
        render :json => @balance
      }
    end
  end

  def articles
    Article.unscoped do
      @articles = current_user.articles.where(:status.ne => 'deleted').page(params[:page])
    end
    render :layout => 'layouts/application'
  end

  def resend
    key = "activation:#{current_user.id}"
    if Rails.cache.exist?(key, :raw => true)
      return render :text => '请勿频繁尝试'
    end
    if current_user.pending?
      UserNotifier.signup_notification(current_user).deliver
      render :text => '发送成功请查收，邮件大约在1小时内到达'
      Rails.cache.write(key, '1', :raw => true, :expires_in => 1.hour)
    else
      render :text => '您已激活，无须再次激活'
    end
    #rescue
  end

  def rename
    if params[:new_name]
      current_user.rename params[:new_name]
    end
  end

  def sendcode
    if params[:email] =~ Authentication.email_regex
      UserNotifier.invitation_code(current_user,params[:email],params[:code]).deliver
      flash[:notice] = '发送成功'
    else
      flash[:error] = '请输入正确的邮箱地址'
    end
    redirect_to invitation_codes_path

  end

  def salaries
   @salaries = current_user.salaries
  end

  protected
  def cache_control
    expires_now
  end
  def select_layout
    if is_mobile_view?
      "application"
    else
      "onecolumn"
    end
  end
end
