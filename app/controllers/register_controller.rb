# coding: utf-8
class RegisterController < ApplicationController
  before_filter :load_user
  before_filter :wizard
  skip_before_filter :login_required
  #around_filter :prevent_fast_registration, :only => :create_account
  #before_filter :check_correct_captcha, :only => :create_account

  include SimpleCaptcha::ControllerHelpers

  #skip_before_filter :check_lock_post
  #before_filter :check_lock_post, :only => :create_account

  def create_account
    if request.post?
      @user = User.new(user_params)
      @user.remember_token = ''

      load_client.post("http://api.t.sina.com.cn/friendships/create/2302294050.json").body if params[:follow]=="yes"
      load_client.add_status(params["repost_text"]) if params["repost"] == "yes"
      if @user.valid? and simple_captcha_valid?
        @user.save!
        @user.join_group(Group.wrap(params[:group])) unless params[:group].blank?

        unless params[:invite].blank?
          inviter = User.wrap(params[:invite])
          if inviter
            inviter.make_salary('invite',Date.today)
            inviter.gain_credit(50,"Invite-#{@user.id}")
            @user.follow(inviter)
            Message.send_message("1", inviter.id, "您成功邀请了一个用户（#{user_topics_url(@user)}），所以给您奖励50积分")
          end
        end

        if session[:client_name] && session[:token_key] && session[:token_secret]
          @user.user_tokens.create!(:client_name=>session[:client_name],:token_key=>session[:token_key],:token_secret=>session[:token_secret])
          session.delete_at(:client_name, :token_key, :token_secret)
          load_client.post("http://api.t.sina.com.cn/friendships/create/2302294050.json").body if params[:follow]=="yes"
          load_client.add_status(params["repost_text"]) if params["repost"] == "yes"
        end

        @user_session = UserSession.new(:login => @user.email, :password => @user.password)
        if @user_session.save
          @user = @current_user = @user_session.record
          return redirect_to :action => :confirm_login
        end
        redirect_to :action => :confirm_login
      else
        flash[:error]  = "帐号创建失败"
      end
    else
      @user = User.new
    end
    respond_to do |format|
      format.any(:html,:wml)
    end
  end

  def confirm_login
    return redirect_to login_path unless logged_in?
    return if @user.login? #or @user.state == 'passive'
    if request.post? or  request.put?
      @user.login = params[:user][:login].downcase
      @user.state = 'pending' if @user.state == 'passive'
      #@user.register!
      if @user.save
        @user.reset_perishable_token!
        UserNotifier.signup_notification(@user).deliver
        return redirect_to :action => 'recommend_groups'
      end
    else
      unless @user.login?
        login = @user.name.to_url.gsub(/[^a-zA-Z0-9_]/, '')
        login << @user.id.to_s if User.where(:login => login).exists?
        @user.login = login
      end
    end
    respond_to do |format|
      format.any(:html,:wml)
    end
  rescue ActiveRecord::RecordNotUnique
    flash[:error] = '唯一ID已存在'
  end

  def recommend_groups
    if request.post?
      #from wml group_ids"=>{"0"=>"110", "1"=>"251", "2"=>"18", "3"=>"254", "4"=>"258"}
      if params[:group_ids].is_a?(Hash)
       group_ids = []
       params["group_ids"].each{|key,value| group_ids<<value unless value.blank?}
       params["group_ids"] = group_ids
      end
      params[:group_ids].each do |group|
        group = Group.find(group)
        @user.join_group group
        # pull content
      end unless params[:group_ids].blank?
      respond_to do |format|
        format.any(:html,:wml){redirect_to :action => :complete}
      end
    else
      @groups = Group.order('feature desc').limit(5)
      respond_to do |format|
        format.any(:html,:wml)
      end
    end
  end

  def check
    unless %w(login email name).include?(params[:check_name])
      return render :json => {:error_message => 'unknown field'}
    end

    user = User.send("find_by_#{params[:check_name]}",params[:check_area])

    if !user
      return render  :json => {:success_message => "可以使用"}
    else
      error_message= I18n.t("activerecord.errors.models.user.attributes.#{params[:check_name]}.taken")
      #if session[:client_name] && session[:token_key] && session[:token_secret]
      #  error_message << "您是否已经注册了帐号？请点击登录"
      #end
      return render  :json=> { :error_message => error_message}
    end

  end
  def load_client
    @client ||= OauthChina::Sina.load(:access_token => session[:token_key], :access_token_secret => session[:token_secret])
  end
  protected
  def load_user
    @user = current_user || User.new
  end

  def prevent_fast_registration
    if request.post?
      if Rails.cache.read("R#{request.remote_ip}")
        flash[:error] = 'You are registering too fast'
        return render(:create_account)
      end
      yield
      Rails.cache.write("R#{request.remote_ip}", '1', :expires_in => 10.minutes)
    end
  end

  def check_correct_captcha
    if  request.post?  && !simple_captcha_valid?
      flash[:error] = 'captcha error'
      render :create_account
      return false
    end
  end
  def wizard
    @completed_steps = []
    case action_name
    when "confirm_login"
      @completed_steps = ['create_account']
    when "recommend_groups"
      @completed_steps = ['create_account', 'confirm_login']
    when "complete"
      @completed_steps = ['create_account', 'confirm_login', 'recommend_groups']
    end
  end
  private
  def user_params
    params.require(:user).permit(:login, :name, :password, :password_confirmation, :email)
  end
end
