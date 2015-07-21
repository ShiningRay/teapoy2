# coding: utf-8
class BadgesController < ApplicationController
 # defaults :finder => :find_by_name!
  before_action :find_user

  def index
    @badges = @user.badges.all
  end

  def show

  end

  def find_user
    @user = User.find params[:user_id]
  end
end
