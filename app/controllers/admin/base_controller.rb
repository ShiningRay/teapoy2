# coding: utf-8
class Admin::BaseController < ApplicationController
  layout 'admin'
  # defaults :route_prefix => 'admin'
  #require_role "admin"
  before_filter :check_role
  before_filter :force_https if Rails.env.production?
  before_filter do
    prepend_view_path('app/views/admin')
    logger.debug view_paths
  end
  protected
  def force_https
    if request.protocol != 'https://'
      redirect_to "https://www.bling0.com#{request.path_info}"
    end
  end

  def check_role
    unless logged_in? and current_user.has_role?('admin')
      redirect_to login_path
      return false
    end
  end
end
