# encoding: utf-8
module UsersController::RegistrationAspect
  #extend ActiveSupport::Concern
  def self.included(base)
    base.send :include, SimpleCaptcha::ControllerHelpers if defined?(SimpleCaptcha)
  end
  #module InstanceMethods
    def new
      #session[:return_to] = request.referer
      @inviter = User.wrap(params[:invite]) if params[:invite]
      @user = User.new
      render :layout => 'onecolumn'
    end

    def create
      #logout_keeping_session!
      if Rails.cache.read("R#{request.remote_ip}")
        flash[:error] = 'You are registering too fast'
        return redirect_to(new_user_path)
      end

      @user = User.new(params[:user].permit(:name, :login, :email, :password, :password_confirmation))
      @user.remember_token = ''
      #@user.state = 'active'
=begin
    if simple_captcha_valid? or !params[:device_id].blank?
    else
        flash[:error]  = "验证码错误"
        respond_to do |format|
          format.any(:html, :mobile, :wml) do
            render :action => 'new', :layout => 'onecolumn'
          end
          format.json do
            render :json => @user.errors, :status => :unprocessable_entity
          end
        end
        return
    end
=end
      inviter = User.wrap(params[:invite]) if params[:invite]

      if @user.valid?
        @user.register!
        Rails.cache.write("R#{request.remote_ip}", '1', :expires_in => 10.minutes)

        unless params[:group].blank?
          @user.join_group(Group.wrap(params[:group]))
        end

        if inviter
          inviter.make_salary('invite',Date.today)
          inviter.gain_credit(50, "Invite-#{@user.id}")
          @user.follow(inviter)
          Message.send_system_message(inviter.id, "您成功邀请了一个用户（#{user_topics_url(@user)}），所以给您奖励50积分")
        end

        unless params[:device_id].blank?
          g= Group.wrap('iphone')
          @user.join_group(g) if g
          d = Device.find_or_create_by_device_id params[:device_id]
          d.user_id = @user.id
          d.save!
        end

        respond_to do |format|
          format.any(:html, :mobile, :wml) do
            #redirect_to :controller => 'my', :action => 'index'
            return
          end
          format.json do
            return render :json => @user, :status => :created, :location => @user
          end
        end
        @user_session = UserSession.new(:login => @user.login, :password => @user.password)
        if @user_session.save
          @user = @current_user = @user_session.record
        else
          return redirect_to login_path
        end
      else
        flash[:error]  = "帐号创建失败"
        respond_to do |format|
          format.any(:html, :mobile, :wml) do
            render :action => 'new', :layout => 'onecolumn'
          end
          format.json do
            render :json => @user.errors, :status => :unprocessable_entity
          end
        end
      end
    end
    def activate
      #logout_keeping_session!
      @user = User.find_using_perishable_token(params[:activation_code], 1.week)
      case
      when (!params[:activation_code].blank?) && @user && !@user.active?
        @user.activate!
        flash[:notice] = "激活成功！<br />您现在可以登录网站了。"
        redirect_to login_path
      when params[:activation_code].blank?
        flash[:error] = "激活码有误，请点击激活邮件中的激活链接。"
        redirect_back_or_default('/')
      else
        flash[:error]  = "激活码已经过期，您可能已经激活成功，请尝试登录网站。如果无法登录，请重新注册。"
        redirect_back_or_default('/')
      end
    end


    def check_invitation_code
      code=params[:invitation_code].upcase.gsub(/\W/, '')
      code=InvitationCode.find :first,:conditions => ["code='#{code}'"]
      if code && !code.consumer_id
        return render  :text=> "激活码可以使用"
      else
        return render  :text=> "无效的激活码"
      end
    end
  #end
end
