# -*- coding: utf-8 -*-
class TopicsController < ApplicationController
  before_action :find_group
  before_action :find_user, if: -> { params[:user_id].present? }
  before_action :find_topic, only: %i(show edit update destroy unpublish links mark)

  rescue_from User::NotAuthorized ,with: :group_is_secret
  # check_duplicate 'topic/content', only: :create
  rescue_from Mongoid::Errors::DocumentNotFound, with: :show_404

  around_filter only: [:edit, :create] do |controller, action|
    Topic.unscoped do
      action.call
    end
  end
  #load_and_authorize_resource :group
  #load_and_authorize_resource :topic, through: :group
  # cache_sweeper :topic_sweeper
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
    topics = @group.pending_topics.page(params[:page])
    respond_with topics
  end


  # :scope/:order/:filter
  # scope:
  #   group_id: all/topics stands for all
  #   tag_id
  # order:
  #   latest, day, week, month, year, trending
  # filter
  # page
  def index
    # TODO: refactor groups finding
    if params[:group_id]
      if params[:group_id] == 'all' or params[:group_id] == 'topics' and @group.blank?
        gids = Group.not_show_in_list.collect{|g|g.id}
        scope = Topic.unscoped.where(status: 'publish').where.not(:group_id => gids)
      else
        find_group
        return show_404 unless @group
        raise User::NotAuthorized if @group and @group.private and (not logged_in? or !current_user.is_member_of?(@group))
        return render template: "/groups/pending" if @group.status == "pending" # raise error and rescue from to render error pages
        scope = @group.public_topics.where(status: 'publish')
      end
    end

    #scope = scope.public_topics.where('topics.created_at <= ?', Time.now)
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
        scope = scope.after(Time.at(ago))
      end
    elsif params[:order] == "latest"
      @order = "latest"
      scope = scope.latest_created
    else
      params[:order] = 'latest_replied'
      scope = scope.latest_replied
    end

    scope = scope.where(:id.gt => params[:id]).sort(id: -1) if params[:after]
    scope = scope.where(:id.lt => params[:id]).sort(id: 1) if params[:before]

    @topics = scope.includes(:group, :user).page(params[:page])

    respond_to do |format|
      format.html
      format.json do
        render json: @topics, callback: params[:callback]
      end
      format.wml
    end
  end

  def new
    #find_group
    return login_required unless logged_in? or (@group && @group.preferred_guest_can_post?)
    return render template:"/groups/pending" if @group && @group.status == "pending"
    @group ||=  Group.find 1
    @topic = Topic.new
    # @topic.attachments = [Post.new]
    @topic.title = params[:title]
    @topic.status = 'publish'
    @topic.group_id ||= 1
    @topic.attachments.build
    @topic.top_post
  end

  def create
    if params[:group_id] and params[:group_id] != 'all'
      @group = Group.find_by_alias! params[:group_id]
    else
      @group = Group.find(params[:topic][:group_id] || 1)
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
    topic = topic_params

    if request.post? and topic # it is a request and has params, a good request.
      #topic[:content] = ActionController::Base.helpers.sanitize topic[:content]
      @topic_form = TopicForm.new(current_user, @group.topics.new)

      @topic = @topic_form.topic

      if @topic_form.validate(topic_params) && @topic_form.save

        current_user.subscribe @topic if logged_in?
        respond_to do |format|
          format.any(:html, :wml) {
            if @topic.status == 'publish'
              redirect_to topic_path(@group, @topic)
            else
              flash[:notice]= '您的文章正在等待审核'
              redirect_to group_path(@group)
            end
          }
          format.json {
            #render nothing: true, status: :created, location: [@group, @topic]
            render json: @topic
          }
          format.js
        end
      else
        error_return.call(@topic_form.topic.errors.full_messages)
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
    topics = @group.public_topics.latest.before.includes(:top_post).page(params[:page])
    topics.reject!{|a| a.top_post.nil? }
    #render template: 'topics/index'
    if topics.size == 0
      render text: '<?xml version="1.0" encoding="UTF-8"?><rss></rss>', status: :not_found if topics.empty?
    else
      render :index
    end
  end

  # Please Refer to ScoreMetal
  def scores
    ids = params[:ids].split(/ |\+/).collect{|i|i.to_i}
    s = Topic.find_all_by_id(ids)
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
        json['subscribed'] = !!watched[['Topic', id]]
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
    resource.save
    respond_with resource, location: [resource.group, resource]
  end

  def search
    @list_view = true
    @term = params[:term] || ""
    @term.strip!
    if params[:group_id] and params[:group_id] != 'all' and params[:group_id] != 'topics'
      @group = Group.find_by_alias params[:group_id]
      collection = @group.topics
    else
      collection = Topic
    end

    if @term.size > 1
      t= Regexp.new @term
      topics = collection.public_topics.where(:title => t).page(params[:page])
    else
      redirect_to topics_path(@group)
    end
    #render action: :index
  end

  def show
    if params[:group_id] == 'topics'
      @topic = Topic.find params[:id]
      @group = topic.group unless @group
      return redirect_to topic_path(@group, topic, format: params[:format]) unless request.format == :json
    end

    return show_404 unless @topic
    authorize @topic
    # expires_now if browser.opera?


    @posts = @topic.posts.all
    respond_to do |format|
      format.html
      format.json {
        render json: @topic
      }
    end
    MarkingReadWorker.perform_async(current_user.id, topic.id, topic.comments.size-1) if logged_in?
  end

  def mark
    MarkingReadWorker.perform_async(current_user.id, topic.id) if logged_in?
    Inbox.where(user_id: current_user.id, topic_id: topic.id).first.try(:read!)
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

      topic = @group.topics.wrap! params[:id]
      topic.operator = current_user.id
      topic.move_to(dest_group, (params[:repost] == '1'))
      Message.send_message(current_user.id, topic.user_id, "您的帖子被#{current_user.name_or_login}移到了#{dest_group.name}中。地址是：#{topic_url(dest_group,topic)}")
      #@topic.score.group_id = params[:group_id]
      #@topic.save!
      #@topic.score.save!
      if params[:repost] == '1'
        redirect_to topic_path(@group, topic)
      else
        redirect_to topic_path(dest_group, topic)
      end
    else
      redirect_to :back
    end
  end

  def move_out
    @group = Group.find_by_alias params[:group_id]
    return render text: '没有权限移动帖子' unless (current_user.is_admin? || current_user.own_group?(@group))

    Topic.unscoped do
      topic = @group.topics.find params[:id]
    end

    topic.move_out
    Message.send_message(current_user.id, topic.user_id, "您的帖子被#{@group.name}小组的组长移到了水库中。地址是：#{topic_url(Group.find(1),topic)}")
    respond_to do |format|
      format.any(:html,:mobile,:wml){
        redirect_to pending_topics_path(@group)
      }
      format.json{
        render json:{}
      }
    end
  end

  def destroy
    @group = topic.group
    if current_user.own_topic?(topic) or @group.owner_id == current_user.id or current_user.is_admin?
      topic.destroy
      respond_to do |format|
        format.html {
          if request.xhr?
            render text: '', layout: false
          else
            redirect_to group_topics_path(@group)
          end
        }
        format.any(:mobile, :wml) {
          redirect_to group_topics_path(@group)
        }
        format.js
      end
    else
      flash[:error] = '你没有权限删除这篇帖子'
      respond_to do |format|
        format.any(:html,:mobile,:wml){
          redirect_to group_topics_path(@group)
        }
      end
    end
  end

  def subscribe
    raise User::NotAuthorized unless logged_in?
    @group = Group.find_by_alias! params[:group_id]
    topic = @group.topics.find params[:id]
    current_user.subscribe topic
    respond_to do |format|
      format.html do
        if request.xhr?
          render topic
        else
          redirect_to topic_path(topic.group, topic)
        end
      end
      format.js
    end
  end

  def unsubscribe
    raise User::NotAuthorized unless logged_in?

    @group = Group.wrap params[:group_id]
    topic = @group.topics.wrap params[:id]
    current_user.unsubscribe topic
    respond_to do |format|
      format.html do
        if request.xhr?
          render topic
        else
          redirect_to topic_path(topic.group, topic)
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
      topic = Topic.new params[:topic]
      logger.debug current_user
      if topic.group
        topic = @post.repost_to current_user.id, topic.group_id, false, topic.title
        if topic
          return redirect_to(topic_path(topic.group, topic))
        else
        end
      end
    else
      topic = Topic.new
      topic.user_id = current_user.id

      if @post.topic.title?
        if @post.floor > 0
          topic.title = "转自#{@post.user.name_or_login}对#{@post.topic.title}的回复"
        else
          topic.title = "转:#{@post.topic.title}"
        end
      end
      render layout: false if request.xhr?
    end
  end

  def publish
    @group = Group.wrap(params[:group_id])
    return render text: "对不起，你没有权限修改" if @group.owner_id != current_user.id
    topic = @group.pending_topics.find(params[:id])
    topic.status = 'publish'
    topic.operator = current_user.id
    topic.created_at = Time.now
    topic.save!
    respond_to do |format|
      format.any(:html,:wml,:mobile){
       redirect_to pending_topics_path(@group)
      }
      format.json{
        result = {}
        result[:status] =  topic.status
        render json:result
      }
    end
  end

  def dismiss
    topic = Topic.find params[:id]
    item = Inbox.by_user(current_user).by_topic(topic)
    item.destroy
    current_user.unsubscribe(topic) if current_user.has_subscribed?(topic)
    render text: ''
  end

  protected

  def group_is_secret
    flash[:notice] = '这个是私秘小组'
    render action: 'forbidden', controller: 'groups', status: :forbidden
  end
  def find_group(group_id=params[:group_id])
    @group = Group.find_by_alias! group_id
    seo_for_group if @group
    begin
      super
    rescue NoMethodError
    end
  end
  private

  def topic_params
    params.require(:topic).permit(:group_id, :title, :content,
      {top_post_attributes: [:type, :content, :picture, :image_url]},
      :status, :picture, :uncommentable, :anonymous, :attachment_ids => [])
  end

  def find_group
    if params[:group_id] and params[:group_id] != 'all'
      @group = Group.find_by_alias(params[:group_id])
      @scope = @group.topics if @group
    end
  end

  def find_user
    @user = User.find_by_login!(params[:user_id])
    @scope = @user.topics
  end

  def scope
    @scope ||= Topic
  end


  def find_topic
    @topic = scope.find params[:id]
  end

  def topic
    @topic ||= scope.find params[:id]
  end

  alias resource topic
end
