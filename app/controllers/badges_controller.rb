# coding: utf-8
class BadgesController < ApplicationController
 # defaults :finder => :find_by_name!
  before_action :find_by_user, if: "params[:user_id]"

  def index

  end

  def show

  end
end
