# coding: utf-8
class Admin::TopicsController < Admin::BaseController
  before_action :find_group
  before_action :resource, only: %i(show edit update destroy set_status move)
  cache_sweeper :topic_sweeper, :only => [:set_status, :batch_set_status, :move]
  #before_filter :find_topic, :except => [:index, :new, :create]
  has_scope :by_status, as: :status, default: 'publish', only: :index
  around_filter :no_scope

  def no_scope
    Topic.unscoped do
      yield
    end
  end

  def index
    @status = params[:status]
    cond = {}
    cond[:id] = params[:id] if params[:id]

    if params[:group_id]
      @group = Group.find(params[:group_id])
      cond[:group_id] = @group.id
    elsif params[:user_id]
      cond.delete(:status)
      @user = User.find_by_login! params[:user_id]
      cond[:user_id] = @user.id
    end
    @statuses = Topic::STATUSES.collect(&:to_s)
    scope = apply_scopes(Topic).page(params[:page]).where(cond)
		@topics = scope.order(id: params[:status] == 'pending' ? :asc : :desc)

    if params[:id] and @topics.size > 0
      @group = @topics[0].group
    end
  end


  def update
#    update! do
    # @topic = resource
    if params[:topic][:title].blank?
      topic.title = nil
      params[:topic][:title] = nil
    end
    topic.no_log = true
    # support alias input
    unless params[:topic][:group_id] =~ /\A\d+\z/
      params[:topic][:group_id] = Group.wrap(params[:topic][:group_id]).id
    end
    topic.user_id = params[:topic].delete("user_id")
    topic.status = params[:topic].delete("status")
    #@topic.operator = current_user
    # if params[:topic][:top_post_attributes]["type"].blank?
    #   Post.connection.execute("UPDATE `posts` SET `type` = NULL  WHERE `posts`.`id` =#{@topic.top_post.id};")
    # else
    #   @topic.top_post.type =  params[:topic][:top_post_attributes][:type]
    # end
    # params[:topic][:top_post_attributes].delete("type")
    topic.update_attributes!(topic_params)
    flash[:notice] = 'updated'

    redirect_to edit_admin_topic_path(topic)
#    end
  end

  def comments
    topic = Topic.find params[:id]
    if topic.comments
      render :partial => 'admin/comments/comment', :collection => topic.comments
    else
      render :nothing => true
    end
  end

  def tickets
    topic = Topic.find params[:id]
    @tickets = topic.tickets.includes(:user => :weight).to_a
    @score = @tickets.inject 0.0 do |s, t|
      tt = t.ticket_type
      u = t.user
      if u and tt
        w = tt.weight
        if w > 0
          s + w * u.ensure_weight.pos_weightd
        else
          s + w * u.ensure_weight.neg_weight
        end
      else
        s
      end
    end
    #ender :partial => 'ticket', :collection => @topic.tickets.find(:all, :include => 'user')
    render :layout => false
  end

  def set_status
    topic = Topic.find params[:id]
   # orig_status = @topic.status
    topic.status = params[:status]
    #@topic.title = @topic.id.to_s if @topic.title.nil? and @topic.status == 'publish'
    topic.save!
    #AuditLogger.log current_user, 'set topic', @topic.id, 'status from', orig_status, 'to', params[:status]
   # TicketWorker.async_judge(:topic_id => @topic.id, :approval => (@topic.status == 'publish'), :reason => '')
    if request.xhr?
      render :nothing => true
    else
      redirect_to :back
    end
  end

  def batch_set_status
    if params[:id]
      Topic.find(params[:id]).each do |topic|
        orig_status = topic.status
        topic.status = params[:status]
        topic.save!
        AuditLogger.log current_user, 'set topic', topic.id, 'status from', orig_status, 'to', params[:status]
        TicketWorker.async_judge(:topic_id => topic.id, :approval => true)
      end
    end
    if params[:delete_else]
      Topic.find(params[:delete_else].split(/,/).collect{|i| i.to_i}).each do |a|
        orig_status = a.status
        a.status = 'private'
        a.save!
        AuditLogger.log current_user, 'set topic', a.id, 'status from', orig_status, 'to private'
        TicketWorker.async_judge(:topic_id => a.id, :approval =>  false)
      end
    end
    redirect_to :back
  end

  def move
    group = Group.find_by_id params[:group_id]
    return redirect_to :back unless group
    params[:id] = [params[:id]] unless params[:id].is_a? Array
    params[:id].each do |i|
      topic = Topic.find i
      original_group = topic.group
      topic.move_to group
      AuditLogger.log current_user, <<log
move \##{topic.id} from #{original_group.id} #{original_group.name} to #{group.id} #{group.name}
log

      topic.anonymous = true if group.preferred_force_anonymous?
      Comment.connection.execute "UPDATE comments SET anonymous = true WHERE topic_id=#{topic.id}" if group.preferred_force_comments_anonymous?
    end
    redirect_to :back
  end
  def track
    Sinatrack.sinapost(params[:id])
  end
  protected
  def find_group
    @group ||= Group.find_by_id params[:group_id]
  end

  def resource
    topic ||= Topic.find params[:id]
  end

  def topic_params
    params.require(:topic).permit!
  end


end
