# coding: utf-8

# 微博登录
class SyncsController < ApplicationController

  def new
    client = WeiboOAuth2::Client.new
    redirect_to client.authorize_url
  end

  def callback
    client = WeiboOAuth2::Client.new
    # FIXME: rescue invalid_grant
    access_token = client.auth_code.get_token(params[:code].to_s) rescue nil
    #这个获得授权用户的信息。
    logger.debug access_token.inspect
    if access_token
      #如果用户已登陆
      if logged_in?
        if t = UserToken.where( provider: params[:type],
                                access_token: access_token.token).first then
          # 如果token尚未绑定到用户则进行绑定
          if t.user_id.blank?
            t.user_id = current_user.id
            t.save!
            flash[:notice] = "绑定成功"
            return redirect_to binding_user_path(current_user)
          else
            flash[:notice] = "绑定失败"
            return redirect_to binding_user_path(current_user)
          end
        else
          # 清除用户原来绑定过的tokens
          current_user.user_tokens.where(provider: params[:type]).delete_all
          UserToken.create(
              user_id: current_user.id,
              provider: params[:type],
              access_token: access_token.token,
              #token_secret: params[:access_token_secret],
              expires_at: access_token.expires_at,
              uid: access_token.params['uid'])
          flash[:notice] = "绑定成功"
          return redirect_to binding_user_path(current_user)
        end
      end

      usertoken = UserToken.where(
        provider: params[:type],
        access_token: results[:access_token],
        secret: results[:access_token_secret]).first

      if usertoken && !usertoken.user.nil?
        user = usertoken.user
        user_session = UserSession.new(user)
        if user_session.save
         @current_user = user_session.record
         return redirect_to "/my/latest"
        end
      else
        #搜索，按照access_token 和access_token_secret 查找用户，如果能找到，直接登录，不能的话跳转到register_path
        token = UserToken.create!(
          provider: params[:type],
          access_token: results[:access_token],
          secret: results[:access_token_secret])
        session[:token_key] = access_token.token
        session[:client_name] = params[:type]
        #session["my_name"] = client.my_name
        #screen_name my_messages_hash[:screen_name]
        #name my_messages_hash[:name]
        #图像地址 my_messages_hash[:profile_image_url]
        #男女 my_messages_hash[:gender]
        # session[:name] =
        #puts my_messages_hash
        # ClientApplication.new()
        #OauthToken.new()
        #在这里把access token and access token secret存到db
        #下次使用的时候:
        #client = OauthChina::Sina.load(access_token: "xx", access_token_secret: "xxx")
        #client.add_status("同步到新浪微薄..")
        flash[:notice] = "授权成功！"
        return redirect_to signup_path
      end
    else
      return  redirect_to root_path
      flash[:notice] = "授权失败!"
    end
  end
end
