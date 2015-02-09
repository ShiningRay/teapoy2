# coding: utf-8
class Admin::EmailsController < Admin::BaseController

  def create
    if request.post?
      users = User.all
      users = params[:group_id].blank?? User.all : Group.wrap(params[:group_id]).members
      User.deliver_mass_email(users,params[:title],params[:content])
    end
  end
end

