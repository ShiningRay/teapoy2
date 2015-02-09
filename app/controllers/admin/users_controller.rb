# encoding: utf-8
class Admin::UsersController < Admin::BaseController
  before_filter :find_user, :except => [:index, :new, :create]
  has_scope :by_state

  def index

    unless params[:search].blank?
      params[:search].strip!
      p = apply_scopes(User)
      str = "%#{params[:search]}%"
      @users = p.where("login LIKE ? or name like ? or email like ?", str, str, str).order("id DESC").page(params[:page])
      #return redirect_to admin_user_path(@users.first) if @users.size == 1
    else
      #cond = {}
      #cond[:state] = params[:state] if params[:state]
      @users = apply_scopes(User).page(params[:page]).order("id DESC")
    end
  end

  def show

  end

  def edit

  end

  def update
    @user.update_attributes! params[:user]
#    @user.badge_ids = params[:user][:badge_ids]
    @user.role_ids  = params[:user][:role_ids]
    @user.badge_ids = params[:user][:badge_ids]
#    @user.ensure_weight.update_attribute("adjust",params[:user][:adjust])
    flash[:notice] = "User #{@user.id} updated"
    redirect_to admin_user_path(@user)
  end

  def new
    @user = User.new
  end

  def create
    create! do
      redirect_to admin_user_path(@user)
    end
  end

  def activate
    state_change
  end

  def suspend
    state_change
  end

  def unsuspend
    state_change
  end

  def state_change
    return unless %w(suspend activate unsuspend).include?(action_name)
    m = "#{action_name}!"
    @user.send m
    state_change_render
  end
  protected :state_change

  def state_change_render
    respond_to do |wants|
      wants.html {
        if request.xhr?
          render :partial => 'user_row', :object => @user, :as => :user
        else
          redirect_to admin_users_path
        end
      }
    end
  end
  protected :state_change_render

  def destroy
    @user.delete!
    state_change_render
  end

  def purge
    #AuditLogger.log current_user, 'purge', @user.id, @user.login
    @user.destroy
    redirect_to admin_users_path
  end

  def delete_avatar
    if request.post?
      #AuditLogger.log current_user, 'delete avatar', @user.id, @user.login
      @user = User.find params[:id]
      @user.avatar = nil
      @user.save!
      redirect_to admin_users_path
      #flash[:notice] = "#{@user.id} #{@user.login}的头像已被删除"
    end
  end

  def delete_comments
    if request.post?
      #AuditLogger.log current_user, 'delete comments', @user.id, @user.login
      @user = User.find params[:id]
      @comments=@user.comments.all
      @comments.each do |comment|
        comment.status='private'
        comment.save!
      end
      redirect_to admin_users_path
      # flash[:notice] = "#{@user.id} #{@user.login}的头像已被删除"
    end
  end
  def comments
    @comments=@user.comments
  end

  def tickets
    @tickets=@user.tickets.paginate :page => params[:page],:per_page=>20
  end

  def add_credit
    @user.gain_credit(params[:amount].to_i,params[:reason])
    Message.send_message(current_user.id,@user.id,"#{current_user.name_or_login}给您加了#{params['amount']}积分，理由是#{params[:reason]}")
    redirect_to admin_user_path(@user)
  end

  def publicate_groups
   @groups=  @user.publications(Group)
  end

  def join_group
    @group = Group.wrap(params[:group_id])
    @user.join_group(@group)
    flash[:notice]= I18n.t 'groups.user_joined', :group => @group.name
    respond_to do |format|
      format.html {
        redirect_back_or_default publicate_groups_admin_user_path(@user)
      }
    end
  end

  def quit_group
   @group =  Group.wrap(params[:group_id])
    @user.quit_group(@group)
    flash[:notice]= I18n.t 'groups.user_quited', :group => @group.name
    respond_to do |format|
      format.html do
        redirect_back_or_default publicate_groups_admin_user_path(@user)
      end
    end
  end

  protected
  def find_user
    @user = User.wrap params[:id]
  rescue ActiveRecord::NotFound
    flash[:error] = 'Cannot find such user'
    redirect_to admin_users_path
  end
end
