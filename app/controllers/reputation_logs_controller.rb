# coding: utf-8
class ReputationLogsController < ApplicationController
  before_filter :load_user

  def index
    # @reputation_logs = @user.reputation_logs
    # if params[:group_id]
    #   @group = Group.wrap(params[:group_id])
    #   @reputation_logs = @user.reputation_in(@group).logs
    # end
    render :nothing => true
  end

  protected
  def load_user
    @user =  User.find_by_login!(params[:user_id])
  end
end
