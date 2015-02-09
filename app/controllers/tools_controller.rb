# coding: utf-8

class ToolsController < ApplicationController
  before_filter :login_required
  def query_name_logs
    if params[:target]
      if params[:field].blank? or params[:field] == 'login'
        @user = User.find_by_login params[:target]
      else
        @user = User.find_by_name params[:target]
      end
      if @user
        key = "#{current_user.id}.query_name_logs.#{@user.id}"
        current_user.spend_credit 50, 'query_name_logs' do
          Rails.cache.write(key, :expires_in => 1.hour)
          flash[:notice] = '50 credit spent'
        end unless Rails.cache.exist?(key)
      end
    end
  end
end
