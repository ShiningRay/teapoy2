# coding: utf-8
class ReputationsController < ApplicationController
  before_filter :login_required
  # belongs_to :user, :finder => :find_by_login!
  before_action :find_user
  # actions :only => [:index, :show]
  def index
    @reputations = current_user.reputations
  end

  def show
    resource
  end
  protected
  def begin_of_association_chain
    current_user
  end

  def resource
    @reputation ||= current_user.reputations.find params[:id]
  end
end
