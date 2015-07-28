# coding: utf-8
class PostsController < ApplicationController
  before_filter :check_owner, :only => [:edit, :update, :destroy]
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy, :up, :dn]

  before_action :resource, only: %i(edit update destroy)
  def check_owner
    if logged_in? && ((resource.user_id.blank? ? current_user.own_group?(resource.group) : (current_user == resource.user))|| current_user.is_admin?)
    else
      render :text => 'forbidden', :status => 403
      return false
    end
  end
  protected :check_owner

  # GET /comments
  def index
    if params[:group_id] == 'topics'
      @topic = Topic.find params[:topic_id] unless topic
      @group = topic.group unless @group
      return redirect_to _topic_comments_path(@group, topic)
    end
    @group = Group.find_by_alias params[:group_id] unless @group
    @topic = @group.topics.wrap! params[:topic_id] unless topic
    #if request.xhr?
    @posts = topic.posts.includes(:user).page(params[:page])

    if params[:before]
      @posts = @posts.take_while { |comment| comment.floor < params[:before].to_i }
    end
    MarkingReadWorker.perform_async(current_user.id, topic.id, @posts.last.try(:floor).to_i) if @posts.size > 0 and logged_in?
    #elsif @topic
    #  @posts = @topic.posts.includes(:user).page(params[:page])
    #end

    #expires_in 1.minute, 'max-stale' => 1.day, :public => true
    #opt = {}
    #opt[:public] = true unless is_mobile_device?
    #opt[:last_modified] = @topic.updated_at.utc
    #opt[:etag] = [@topic, @posts.count] if @posts
    #if stale?(opt)

    respond_to do |format|
      format.html do
        render @posts if request.xhr?
      end

      format.json
      format.wml
    end
  end

  def show

    respond_with resource
  end

  # POST /comments
  # POST /comments.xml
  def create
    if not logged_in? and params[:user]
      #logout_keeping_session!
      user_session = UserSession.new(params.require(:user).permit(:login, :email, :password))
      if user_session.save
        @current_user = user_session.record
        #cookies['login'] = {:value => current_user.to_json(:only => [:id, :login, :state]), :expires => 10.minutes.from_now}
      else
        return render :text => I18n.t("session.login_failed"), :status => :forbidden
      end

    end

    return_with_text = Proc.new do |text|
      respond_to do |format|
        format.any(:html, :wml) {
          if request.xhr?
            return render :text => text, :status => :unprocessable_entity
          else
            flash[:error] = text
            return render :new, :status => :unprocessable_entity
          end
        }

        format.json {
          return render :json => {:error => text}, :status => :unprocessable_entity
        }
        format.js {
          return render :text => "alert(\"#{text}\")"
        }
      end
    end

    if topic #when creating topic's comments
      #    @topic = Topic.find params[:comment] unless @topic
      @group = group = topic.group
      return login_required unless logged_in? #or @group.preferred_guest_can_reply?
      p = post_params
      return render :text => '数据错误，如果您用的是手机，请访问手机版博聆 http://m.bling0.com' if p.blank?

      if picture = p.delete(:picture)
        @attachment = Attachment.create file: picture, uploader_id: current_user.id
        p[:content] << "![#{@attachment[:file]}](#{@attachment.file.url})"
        p[:attachment_ids] = [@attachment.id.to_s]
      end

      @post = post = Post.new(p)
      @post.parent_floor ||= 0
      @parent = topic.posts.find_by floor: @post.parent_floor
      @post.group_id = group.id
      @post.translate_instruct = true if browser.mobile?

      if topic.comment_status == 'closed'
        return_with_text.call(I18n.t('topics.cannot_reply_to_closed_topic'))
      end
      #comment.content = ActionController::Base.helpers.sanitize comment.content
      post.content ||= ''
      post.anonymous ||= false

      if logged_in?
        # FIXME: move subscribe to observer
        # current_user.subscribe(@topic)
        post.user_id = current_user.id
      end

      topic.posts << post

      begin
        if !params[:reward].blank?
          r = params[:reward].to_i
          if r > 0
            p[:amount] = r
            post.described_target = Reward.make current_user, @parent, r, post.anonymous
            post.save
          end
        end
      rescue Balance::InsufficientFunds
        return_with_text.call("余额不足")
      end

      respond_to do |format|
        format.html {
          if request.xhr? or params[:from_xhr].to_i==1
#            if comment.status == 'publish'
            if post.persisted?
              render post
            else
              render :text => post.errors.full_messages
            end
#            else
#              render :text => I18n.t( post.public? ? 'comments.reply_successfully' : "comments.await_moderation" )
#            end
          else
            redirect_to topic_path(topic.group, topic, anchor: "post_#{post.id}")
          end
        }
        format.wml {
          redirect_to topic_path(topic.group, topic)
        }
        format.json {
          if post.persisted?
            post_json = @post.as_json
            post_json["html"] = render_to_string(:partial => "posts/#{@post.class.name.underscore}", :object => @post)
            post_json["rate_status"] = logged_in? ? current_user.rate_status(@post) : 'unvoted'
            render :json => post_json, :status => :created #, :location => [:group]
          else
            render :json => @post.errors, :status => :unprocessable_entity
          end
        }
        format.js
      end

      if logged_in?
        expire_fragment [:collapse_wap, current_user.id, topic.id]
        expire_fragment [:collapse_mobile, current_user.id, topic.id]
      end

      if params[:vote] and logged_in?
        score = params[:vote].to_i
        return if score <= 0
        score = 1 if score > 1
        score = -1 if score < -1

        current_user.vote @parent, score if @parent
      end
    end
  end

  def new
    @group = Group.find_by_alias params[:group_id] unless @group
    @topic = @group.topics.find params[:topic_id] unless topic
    @parent = @topic.posts.find_by_floor params[:parent_id].to_i
    @post = @topic.posts.new

    if @parent
      @post.parent_id = @parent.id
      @post.content = "回复#{@parent.floor}L #{@parent.user.name_or_login}: "
    else
      flash[:error] = '您要回复的评论不存在，可能已被删除'
      @parent = topic.top_post
      @post.parent_id = 0
    end

    @post.user_id = current_user.id
    @post.group_id = topic.group_id

    respond_to do |format|
      format.any(:html, :wml)
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

  def destroy
    destroy! do |format|
      format.html {
        render :nothing => true if request.xhr?
      }
      format.wml {
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

  def up
    @post = resource
    vote(@post, 1)
  end

  def dn
    @post = resource
    #current_user.spend_credit(10, "vote down \##{@post.topic.id} #{@post.floor > 0 && @post.floor}") if logged_in?
    vote(@post, -1)
  end

  protected
  def vote(post, score)
    current_user.vote post, score
    current_user.mark_topic_as_read(post.topic)
    post.reload

    respond_to do |format|
      format.html {
        if request.xhr?
          render :text => post.score
        else
          redirect_back_or_default(request.referer || topic_path(post.group||post.topic.group, post.topic))
        end
      }
      format.wml { show_notice "您为帖子投了#{score > 0 ? '支持' : '反对'}，现在帖子得分为#{post.score}" }
      format.json do
        render :json => {:neg => post.neg, :score => post.score, :pos => post.pos}
      end
      format.js
    end
  end


  def resource
    @post ||= Post.find params[:id]
  end

  def topic
    @topic ||= Topic.find params[:topic_id]
  end
  def group
    @group ||= Group.wrap params[:group_id]
  end

  def post_params
    params.require(:post).permit(:content, :picture, :anonymous, :parent_floor, :attachment_ids => [])
  end
end
