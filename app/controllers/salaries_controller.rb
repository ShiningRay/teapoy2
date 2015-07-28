# coding: utf-8
class SalariesController < ApplicationController
  before_filter :login_required

  def index
    @salaries = current_user.salaries.page params[:page]
  end

  def get
    if resource
      resource.paid!
      amount = resource.amount
    else
      @salaries = current_user.salaries.unpaid.find params[:ids]
      amount = 0
      @salaries.each do |s|
        s.paid!
        amount += s.amount
      end
    end
    respond_to do |format|
      format.any(:html, :wml) do
        flash[:notice] = "您领取了#{amount}点积分"
        redirect_to salaries_path
      end
      format.json do
        render :json=> {:salary => amount, :status => 1}
      end
    end
  end

  def get_all
    amount = 0
    current_user.salaries.unpaid.each do |s|
      begin
      s.paid!
      amount += s.amount
      rescue
      next
      end
    end
    respond_to  do |format|
      format.any(:html, :wml) do
        flash[:notice] = "您领取了#{amount}点积分"
        redirect_to salaries_path
      end
      format.json do
        render :json => {:salary => amount, :status => 1}
      end
    end
  end

  protected
    def collection
      @salaries ||= end_of_association_chain.page(params[:page])
    end
    def begin_of_association_chain
      current_user
    end
    def end_of_association_chain
      current_user.salaries
    end
    def resource
      @salary ||= end_of_association_chain.find params[:id]
    end
end
