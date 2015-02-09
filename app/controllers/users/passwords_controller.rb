class Users::PasswordsController < ApplicationController
	before_filter :login_required

  def edit
  end

  def update
    @user = current_user
    if current_user.valid_password?(params[:old_password])
      current_user.password = params[:password]
      current_user.password_confirmation = params[:password_confirmation]
      if current_user.changed? && current_user.save!
        flash[:error]='设置新密码成功'
        return redirect_to current_user
      else
        flash[:error]='密码太短或不匹配'
      end
    else
      flash[:error]='原始密码错误'
    end
    render :edit
  end
end
