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

  def new
    @group = Group.find_by_alias params[:group_id] unless @group
    topic = @group.topics.wrap params[:topic_id] unless topic
    @parent = topic.posts.find_by_floor params[:parent_id].to_i
    @post = topic.posts.new

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
      format.any(:html, :mobile, :wml)
    end
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
        format.any(:html, :mobile, :wml) {
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

    topic = Topic.find params[:topic_id]

    if topic #when creating topic's comments
      #    @topic = Topic.find params[:comment] unless @topic
      @group = group = topic.group
      return login_required unless logged_in? or @group.preferred_guest_can_reply?
      p = comment_params || post_params
      return render :text => '数据错误，如果您用的是手机，请访问手机版博聆 http://m.bling0.com' if p.blank?
      if !p[:picture].blank?
        p[:type] = 'Picture'
        transform_binary(p, :picture)
      else
        p.delete :picture
      end

      @comment = comment = Post.new(p)
      @parent = (topic.posts.find_by_floor p[:parent_id].to_i) || topic.top_post
      @comment.parent_id = @parent.id

      @comment.group_id = group.id
      @comment.translate_instruct = true if browser.mobile?

      if group.options.only_member_can_reply?
        unless logged_in?
          return_with_text.call("请登录")
        else
          if current_user.state != 'active'
            return_with_text.call(I18n.t('users.must_activate'))
          end
        end
      end
      if topic.comment_status == 'closed'
        return_with_text.call(I18n.t('topics.cannot_reply_to_closed_topic'))
      end
      #comment.content = ActionController::Base.helpers.sanitize comment.content
      comment.content ||= ''
      comment.content.strip!
      comment.anonymous ||= false

      if logged_in?
        # FIXME: move subscribe to observer
        # current_user.subscribe(@topic)
        comment.user_id = current_user.id
        comment.anonymous = true if group.options.force_comments_anonymous?
      else
        comment.anonymous = true
      end
      topic.posts << comment
      # binding.pry

      begin
        if !params[:reward].blank?
          r = params[:reward].to_i
          if r > 0
            p[:amount] = r
            comment.described_target = Reward.make current_user, @parent, r, comment.anonymous
            comment.save
          end
        end
      rescue Balance::InsufficientFunds
        return_with_text.call("余额不足")
      end

      respond_to do |format|
        format.any(:html, :mobile) {
          if request.xhr? or params[:from_xhr].to_i==1
#            if comment.status == 'publish'
            if comment.persisted?
              @theme='' if params[:use_theme]=="no"
              render :partial => 'comments/comment', :object => comment
            else
              render :text => comment.errors.full_messages
            end
#            else
#              render :text => I18n.t( comment.public? ? 'comments.reply_successfully' : "comments.await_moderation" )
#            end
          else
            redirect_to topic_path(topic.group, topic, anchor: "post_#{comment.id}")
          end
        }
        format.wml {
          redirect_to topic_path(topic.group, topic)
        }
        format.json {
          if comment.persisted?
            comment_json = @comment.as_json
            comment_json["html"] = render_to_string(:partial => "posts/#{@comment.class.name.underscore}", :object => @comment)
            comment_json["rate_status"] = logged_in? ? current_user.rate_status(@comment) : 'unvoted'
            render :json => comment_json, :status => :created #, :location => [:group]
          else
            render :json => @comment.errors, :status => :unprocessable_entity
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

        if @parent && !(r = current_user.has_rated?(@parent)) or r != score
          current_user.vote @parent, score
        end
      end
    end
  end

  private
  def comment_params
    params[:comment] && params.require(:comment).permit(:content, :picture, :anonymous)
  end

  def post_params
    params[:post] && params.require(:post).permit(:content, :picture, :anonymous)
  end

  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def topic
    @topic ||= Topic.find params[:topic_id]
  end

end
