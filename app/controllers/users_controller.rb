# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  # Protect these actions behind an admin login
  before_filter :login_required, :only => [:index,:update, :follow, :unfollow, :binding]
  #skip_before_filter :login_required, :except =>
  before_filter :find_user, :only => [:suspend,:comments, :unsuspend, :destroy, :purge, :show, :edit, :update, :followings, :followers, :follow, :unfollow,:binding, :dislike,:cancel_dislike]

  #super_caches_page :show
  include RegistrationAspect
  # caches_page_for_anonymous :index

  def index
    @user = current_user
    if params[:group_id]
      @group =  Group.find_by_alias params[:group_id]
      scope = User.joins(:memberships).joins("LEFT  JOIN reputations ON users.id = reputations.user_id and (reputations.group_id = memberships.group_id )").select("users.* , memberships.role as membership_role,memberships.group_id as membership_group_id, reputations.value ").where("memberships.group_id = ? ",@group.id)
      if params[:search]
        str="%#{params[:search]}%"
        scope = scope.where(["name LIKE ? or login LIKE ? ",str,str])
      else
        cond = {}
        cond["memberships.role"] = params[:state] if params[:state]
        scope = scope.where(cond)
      end
      @users = scope.page(params[:page]).order("reputations.value desc,id asc").uniq
    elsif params[:search]
      str = "%#{params[:search]}%"
      @users =  User.where("name LIKE ? or login LIKE ? ",str,str).page(params[:page])
    else
      redirect_to '/'
    end
  end

  def token
    d = Device.find_or_create_by_device_id params[:device_id]
    d.token = params[:token]
    d.save!
    head :ok
  end

  def show
    if @user.suspended? or @user.deleted?
      return show_404
    end
    respond_with @user
  end

  def search
    if params[:search] =~ /\#?(\d+)/
      user = User.find_by_id $1
      return redirect_to user if user
    end
    if params[:search].size < 1
      flash[:error] = '请输入要查找的用户名的一部分'
    else
      @users = User.paginate :page => params[:page],
        :conditions => ["login LIKE ?", "%#{params[:search]}%"]
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def comments
    return unless @user.state == 'active'
    # return access_denied unless @user.has_role? 'doctor'
    @is_current = (logged_in? and current_user == @user)
    @title_name = @user.login
    if @is_current
      @comments = @user.comments.public.paginate  :order => 'id desc', :page => params[:page]
    else
      @comments = @user.comments.paginate :conditions => ["anonymous <> 1 and status='publish'"], :order => 'id desc', :page => params[:page]
    end
    current_user.clear_notification 'new_follower', @user.id if logged_in?
  end

  def my
    render :json => current_user
  end

  def edit
    return access_denied unless current_user == @user
  end

  def binding
  end


  def update
    return access_denied unless current_user == @user
    params[:user].each_pair do |key, value|
      params[:user].delete(key) if value.blank?
    end

    if !params[:user][:name].blank? and  !User.exists?(:name=>params[:user][:name])
       if @user.balance.credit >= 200
          if @user.rename params[:user].delete(:name)
            @rename_result = "昵称修改成功，扣除200积分"
            Message.send_message(current_user.id,@user.id,"您的昵称已经修改，所以扣除您200积分")
           else
             @rename_result = "昵称修改失败"
             return render :edit
          end
       else
         @rename_result = "对不起，您的积分不足200。不能修改昵称"
         return render :edit
       end
    end

    if @user.update_attributes user_params
      flash[:notice] = '更新成功，如果您更改了邮箱请重新激活'
      redirect_to @user
    else
      render :edit
    end
  end


=begin
  def suspend
    @user.suspend!
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
=end

  def followings
    @title_name = "关注#{@user.login}的朋友"
    @users = Kaminari.paginate_array(@user.followings).page(params[:page])
      respond_to do |format|
      format.any(:html, :wml) {
        render :index
      }
      format.json {
        render :json => @users
      }
    end
  end

  def followers
    @title_name = "#{@user.login}关注的好友"
    @users = Kaminari.paginate_array(@user.followers).page(params[:page])
    respond_to do |format|
      format.any(:html, :wml) {
        render :index
      }
    end
  end


  def follow
    if current_user != @user
      current_user.follow @user
      #a=Notification.find(:first,:conditions=>{:user_id => current_user.id, :key => "new_follower.#{@user.id}", :content => @user.id})
      #a.read! unless a.nil?
      #Notification.create :user_id => @user.id, :key => "new_follower.#{current_user.id}", :content => current_user.id rescue nil
    end
    respond_to do |format|
      format.any(:html, :wml)do
        flash[:notice]="您已经关注了#{@user.login}"
        redirect_back_or_default( request.referer || user_path(@user))
      end
      format.json do
        render :json => {:following => true,:opposite_href=>unfollow_user_path(@user),:text=>"取消关注"}
      end
    end
  end

  def unfollow
    #a=Notification.find(:first,:conditions=>{:user_id => current_user.id, :key => "new_follower.#{@user.id}", :content => @user.id})
    #a.read! unless a.nil?
    current_user.unfollow @user

    respond_to do |format|
      format.any(:html, :wml) do
        set_flash :success, object: @user
        redirect_back_or_default( request.referer || user_path(@user))
      end
      format.json do
        render :json => {:following => false,:opposite_href=>follow_user_path(@user),:text=>"关注"}
      end
    end
  end

  def dislike
    current_user.dislike! @user
    redirect_to :back
  end

  def cancel_dislike
    current_user.cancel_dislike! @user
    redirect_to :back
  end

  def lists
    @lists = current_user.lists.find(:all)
  end

  def invite_to_group
    group = Group.find(params[:group_id])
    user = User.find_by_email(params[:email])
    if user
      Message.create!(:owner_id=>current_user.id, :sender_id => current_user.id, :recipient_id=> user.id,:content=>"您的好友#{current_user.name_or_login}邀请您加入圈子#{group.name}，地址是#{group_url(group)}",:read => true)
      Message.create!(:owner_id=>user.id, :sender_id => current_user.id, :recipient_id=> user.id,:content=>"您的好友#{current_user.name_or_login}邀请您加入圈子#{group.name}，地址是#{group_url(group)}")
      else
      InviteMailer.invite_to_group(current_user,group,params[:email]).deliver unless group.nil?
    end
    flash[:notice] = "邀请成功"
    redirect_to :back
   # return render :json => {:text => "邀请成功"}
  end
  protected
  def find_user
    @user = User.find_by_login!(params[:id])
  rescue ActiveRecord::RecordNotFound
    show_404 params[:id]
    return false
  end

  def user_params
    params.require(:user).permit(:avatar, :password, :password_confirmation)
  end
end
