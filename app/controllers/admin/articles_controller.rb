# coding: utf-8
class Admin::ArticlesController < Admin::BaseController
  before_action :find_group
  before_action :resource, only: %i(show edit update destroy set_status move)
  cache_sweeper :article_sweeper, :only => [:set_status, :batch_set_status, :move]
  #before_filter :find_article, :except => [:index, :new, :create]
  has_scope :by_status, as: :status, default: 'publish', only: :index
  around_filter :no_scope

  def no_scope
    Article.unscoped do
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
    @statuses = Article::STATUSES.collect(&:to_s)
		if params[:status] == 'pending'
			@articles = apply_scopes(Article).page(params[:page]).order_by(id: :asc).where(cond)
		else
			@articles = apply_scopes(Article).page(params[:page]).order_by(id: :desc).where(cond)
		end
    if params[:id] and @articles.size > 0
      @group = @articles[0].group
    end
  end


  def update
#    update! do
    # @article = resource
    if params[:article][:title].blank?
      @article.title = nil
      params[:article][:title] = nil
    end
    @article.no_log = true
    # support alias input
    unless params[:article][:group_id] =~ /\A\d+\z/
      params[:article][:group_id] = Group.wrap(params[:article][:group_id]).id
    end
    @article.user_id = params[:article].delete("user_id")
    @article.status = params[:article].delete("status")
    #@article.operator = current_user
    # if params[:article][:top_post_attributes]["type"].blank?
    #   Post.connection.execute("UPDATE `posts` SET `type` = NULL  WHERE `posts`.`id` =#{@article.top_post.id};")
    # else
    #   @article.top_post.type =  params[:article][:top_post_attributes][:type]
    # end
    # params[:article][:top_post_attributes].delete("type")
    @article.update_attributes!(article_params)
    flash[:notice] = 'updated'

    redirect_to edit_admin_article_path(@article)
#    end
  end

  def comments
    @article = Article.find params[:id]
    if @article.comments
      render :partial => 'admin/comments/comment', :collection => @article.comments
    else
      render :nothing => true
    end
  end

  def tickets
    @article = Article.find params[:id]
    @tickets = @article.tickets.includes(:user => :weight).to_a
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
    #ender :partial => 'ticket', :collection => @article.tickets.find(:all, :include => 'user')
    render :layout => false
  end

  def set_status
    @article = Article.find params[:id]
   # orig_status = @article.status
    @article.status = params[:status]
    #@article.title = @article.id.to_s if @article.title.nil? and @article.status == 'publish'
    @article.save!
    #AuditLogger.log current_user, 'set article', @article.id, 'status from', orig_status, 'to', params[:status]
   # TicketWorker.async_judge(:article_id => @article.id, :approval => (@article.status == 'publish'), :reason => '')
    if request.xhr?
      render :nothing => true
    else
      redirect_to :back
    end
  end

  def batch_set_status
    if params[:id]
      Article.find(params[:id]).each do |article|
        orig_status = article.status
        article.status = params[:status]
        article.save!
        AuditLogger.log current_user, 'set article', article.id, 'status from', orig_status, 'to', params[:status]
        TicketWorker.async_judge(:article_id => article.id, :approval => true)
      end
    end
    if params[:delete_else]
      Article.find(params[:delete_else].split(/,/).collect{|i| i.to_i}).each do |a|
        orig_status = a.status
        a.status = 'private'
        a.save!
        AuditLogger.log current_user, 'set article', a.id, 'status from', orig_status, 'to private'
        TicketWorker.async_judge(:article_id => a.id, :approval =>  false)
      end
    end
    redirect_to :back
  end

  def move
    group = Group.find_by_id params[:group_id]
    return redirect_to :back unless group
    params[:id] = [params[:id]] unless params[:id].is_a? Array
    params[:id].each do |i|
      @article = Article.find i
      original_group = @article.group
      @article.move_to group
      AuditLogger.log current_user, <<log
move \##{@article.id} from #{original_group.id} #{original_group.name} to #{group.id} #{group.name}
log

      @article.anonymous = true if group.preferred_force_anonymous?
      Comment.connection.execute "UPDATE comments SET anonymous = true WHERE article_id=#{@article.id}" if group.preferred_force_comments_anonymous?
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
    @article ||= Article.find params[:id]
  end

  def article_params
    params.require(:article).permit!
  end


end
