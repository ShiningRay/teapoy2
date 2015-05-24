# -*- coding: utf-8 -*-
# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  skip_before_filter :login_required
  #skip_before_filter :verify_authenticity_token, :only => [:create]

  # get current session
  def show
    return redirect_to root_path unless logged_in?
    respond_to do |format|
      format.any(:html, :wml){ redirect_to '/' }
      format.json {
        va = current_user.as_json(:only => [:id, :login, :name, :state])
        va['unread_messages_count'] = current_user.unread_messages_count
        va['unread_notifications_count'] = current_user.notifications.unread.count
        va['flash'] = flash unless flash.empty?
        #    va['notifications_count'] = current_user.notifications.count
        #    va['notifications'] = [current_user.notifications.first]
        #cookies['login'] = {:value => va.to_json, :expires => 10.minutes.from_now}
        render :json => va, :callback => params[:callback]
      }
    end
  end

  def new
    return redirect_to '/' if logged_in?
    store_location

    @user_session = UserSession.new
    respond_to do |format|
      format.html
      format.any(:mobile,:wml)
    end
  end

  def create
    @user_session = UserSession.new(user_session_params)
    if @user_session.save
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
#      self.current_user = user
#      new_cookie_flag = (params[:remember_me] == "1")
      #json = current_user.to_json(:only => [:id, :login, :state])
#      handle_remember_cookie! new_cookie_flag
      #cookies['login'] = {:value => json, :expires => 10.minutes.from_now}
      @current_user = @user_session.record
      if session[:client_name] && session[:token_key] && session[:token_secret]
         @current_user.user_tokens << UserToken.find_by_client_name_and_token_key_and_token_secret(session[:client_name],session[:token_key],session[:token_secret])
         session[:client_name] = nil
         session[:token_key] = nil
         session[:token_secret] = nil
      end
      unless params[:device_id].blank?
        d = Device.find_or_create_by_device_id params[:device_id]
        d.user_id = @current_user.id
        d.save!
      end

      respond_to do |format|
        format.any(:html, :wml){
          if @current_user.state == 'passive' || @current_user.login.blank?
            redirect_to :controller => 'register', :action => 'confirm_login'
          else
            redirect_back_or_default '/all'
          end
        }
        format.json {
          va = @current_user.as_json
          va['unread_messages_count'] = @current_user.unread_messages_count
          va['unread_notifications_count'] = @current_user.notifications.unread.count
          va['flash'] = flash unless flash.empty?
          render :json => va
        }
        format.js
      end
    else
      note_failed_signin

#      @login       = params[:login]
#      @remember_me = params[:remember_me]
      respond_to do |format|
        format.any(:html, :mobile,:wml){
          flash[:error] = "错误的用户名/密码组合"
          render :new
        }
        format.json {
          render :json => {:error => "错误的用户名/密码组合"}, :status => 403
        }
      end
    end
  end

  def destroy
    store_location
    if logged_in?
      current_user.reset_persistence_token
      current_user_session.destroy
    end
    expires_now
    respond_to do |format|
      format.any( :html, :mobile,:wml){
        redirect_to '/all'
      }
      format.json {
        render :nothing => true
      }
      format.js
    end
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  private
  def user_session_params
    params.require(:user_session).permit(:login, :email, :password, :remember_me)
  end
end
