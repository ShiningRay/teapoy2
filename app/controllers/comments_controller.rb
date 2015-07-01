# coding: utf-8
class CommentsController < ApplicationController
  before_action :find_topic
  # check_duplicate 'post/content', :only => :create
  #before_filter :oauthenticate, :only => [:create]
  #before_filter :login_required, :except => [:index, :create, :up, :dn,:report]
  before_filter :login_required, :except => %i(index create)
  #load_and_authorize_resource :topic
  #load_and_authorize_resource :post, :throught => :topic
  include PostsHelper

  rescue_from ActiveRecord::RecordNotFound do
    show_404
  end
  # caches_page_for_anonymous :index
  # GET /comments
  # GET /comments.xml
  def index
    if params[:group_id] == 'users'
      @user = User.wrap(params["topic_id"])
      @comments = @user.comments.latest.page(params[:page])
    else
      if params[:group_id] == 'topics'
        @topic = Topic.find params[:topic_id] unless topic
        @group = topic.group unless @group
        return redirect_to _topic_comments_path(@group, topic)
      end
      @group = Group.find_by_alias params[:group_id] unless @group
      @topic = @group.topics.wrap! params[:topic_id] unless topic
      #if request.xhr?
      @comments = topic.comments #.includes(:user)
    end

    if params[:before]
      @comments = @comments.take_while { |comment| comment.floor < params[:before].to_i }
    end
    MarkingReadWorker.perform_async(current_user.id, topic.id, @comments.last.try(:floor).to_i) if @comments.size > 0 and logged_in?
    #elsif @topic
    #  @comments = @topic.comments.includes(:user).page(params[:page])
    #end

    #expires_in 1.minute, 'max-stale' => 1.day, :public => true
    #opt = {}
    #opt[:public] = true unless is_mobile_device?
    #opt[:last_modified] = @topic.updated_at.utc
    #opt[:etag] = [@topic, @comments.count] if @comments
    #if stale?(opt)

    respond_to do |format|
      format.html do
        if topic
          @theme='' if params[:use_theme]=="no"
          render :partial => 'comments/index', :layout => false
        end
      end
      format.json do
        comments_json = @comments.as_json(:except => [:group_id, :status], :expand_user => true)
        comments_json.each_with_index do |item, index|
          item[:html] = render_to_string(:partial => "posts/#{@comments[index].class.name.underscore}", :object => @comments[index])
          item[:rate_status]= logged_in? ? current_user.rate_status(@comments[index]) : 'unvoted'
        end
        render :json => comments_json, :callback => params[:callback]
      end
      format.xml do
        @comments = @comments.page(params[:page])
        expires_in 1.hour
        @comments.collect! do |item|
          {
              :title => "#{item.anonymous ? '匿名用户' : item.user.login}发表于#{@group.name.mb_chars[0, 2]}\##{topic.id}上的评论",
              :link => "#{topic_url(topic)}\#comment-#{item.id}",
              :pubDate => item.created_at,
              :guid => "#{topic_url(topic)}\#comment-#{item.id}",
              :description => item.content
          }
        end
        @comments.reverse!
        render_feed :items => @comments,
                    :title => "#{@group.name}\##{topic.id}中的评论",
                    :pubDate => topic.updated_at
      end
      format.any(:mobile, :wml) { @comments = @comments.page(params[:page]) }
    end
    #end
  end

  private

  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def topic
    @topic ||= Topic.find params[:topic_id]
  end

end
