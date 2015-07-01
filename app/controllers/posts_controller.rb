# coding: utf-8
class PostsController < ApplicationController
  before_filter :check_owner, :only => [:edit, :update, :destroy]
  before_action :resource, only: %i(edit update destroy)
  def check_owner
    if logged_in? && ((resource.user_id.blank? ? current_user.own_group?(resource.group) : (current_user == resource.user))|| current_user.is_admin?)
    else
      render :text => 'forbidden', :status => 403
      return false
    end
  end
  protected :check_owner

  def index
    unless @user
      @user = current_user
      @posts = Post.where('((`posts`.`reshare` = 1 or  `posts`.`parent_id` IS NULL) AND `posts`.`user_id` IN (?))',@user.friend_ids + [@user.id]).order('id desc')
    else
      @posts = @user.posts.order('id desc')
    end

    @post = current_user.posts.new
    # return unless current_user==@user

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  def update
    if resource.update post_params
      respond_to do |format|
        format.html {
          redirect_to group_topic_path(@post.group || @post.topic.group, @post.topic)
        }
      end
    end
  end

  def up
    @post = resource
    vote(@post, 1)
  end

  def dn
    @post = resource
    #current_user.spend_credit(10, "vote down \##{@post.topic.id} #{@post.floor > 0 && @post.floor}") if logged_in?
    vote(@post, -1)
  end

  def repost
    @post = resource
    @group = Group.find params[:group_id]

    if current_user.is_member_of?(@group)
      @post.repost_to current_user.id, @group.id
    end

    respond_to do |format|
      format.html{
        if request.xhr?
          render :text => 'success'
        else
          redirect_to posts_path
        end
      }
      format.js {
        render :nothing => true, :status => :created
      }
    end
  end

  def destroy
    destroy! do |format|
      format.html {
        render :nothing => true if request.xhr?
      }
      format.any(:mobile, :wml) {
        redirect_to group_topic_path(@post.topic)
      }
      format.js
    end
  end

  # Please Refer to ScoreMetal
  def scores
    ids = params[:ids].split(/ |\+/).collect{|i|i.to_i}
    posts = Post.find_all_by_id(ids)
    if logged_in?
      rated = current_user.ratings_for(posts)
      response.headers['Cache-Control'] = 'private'
    else
      response.headers['Cache-Control'] = 'public'
    end

    m = {}

    s.each do |r|
      id = r.id
      json = r.as_json
      if logged_in?
        json['rated'] = rated[id]
      end
      m[id] = json
    end

    respond_to do |format|
      format.json {
        render :json => m
      }
    end
  end

  protected
  def vote(post, score)
    unless logged_in?
      if request.xhr?
        return render :text => ''
      else
        return redirect_to login_path
      end
    end

    if logged_in?
      current_user.vote post, score
      current_user.mark_topic_as_read(post.topic)
      post.reload
    end

    respond_to do |format|
      format.html {
        if request.xhr?
          render :text => post.score
        else
          redirect_back_or_default(request.referer || topic_path(post.group||post.topic.group, post.topic))
        end
      }
      format.any(:mobile, :wml) { show_notice "您为帖子投了#{score > 0 ? '支持' : '反对'}，现在帖子得分为#{post.score}" }
      format.json do
        render :json => {:neg => post.neg, :score => post.score, :pos => post.pos}
      end
      format.js
    end
  end


  def resource
    @post ||= Post.find params[:id]
  end
end
