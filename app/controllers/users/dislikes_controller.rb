class Users::DislikesController < ApplicationController
  respond_to :json
	# custom_actions :only => [:index, :create, :destory]
  #before_filter :login_required
  before_filter :find_user

	def index
    @dislikes = []
    render :json => @dislikes
		#respond_with(@dislikes)
	end

	def create
    # @target = User.wrap params[:id]
    # current_user.dislike! @target
    redirect_to :back
	end

	def destroy
    # target = User.wrap params[:id]
    # current_user.cancel_dislike! target
    redirect_to :back
	end

  protected
  def find_user
    @user = User.wrap params[:user_id]
    return render :nothing => true, :status => :forbidden if current_user != @user
  end
end
