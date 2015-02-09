class Users::AvatarsController < ApplicationController
	before_filter :find_user
	skip_before_filter :verify_authenticity_token
	def edit
		
	end

	def update
    file = params[:file] || params[:avatar] || params[:user][:avatar]
    file.original_filename = SecureRandom.hex if file.original_filename.blank?
		@user.avatar = file
		@user.save
		render :text => 'ok'
	end

	def find_user
		@user = User.wrap! params[:user_id]
		if @user != current_user
			render :text => 'forbidden'
		end
	end
end
