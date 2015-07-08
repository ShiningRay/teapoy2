# coding: utf-8
class AttachmentsController < ApplicationController
  before_action :find_group, except: :upload
  before_action :find_topic, except: :upload
  before_action :resource, only: %i(show set_price)
  before_action :login_required, only: :upload
  # before_filter :check_owner, only: :show
  def index

  end

  def show

  end

  def upload
    @attachment = Attachment.new uploader_id: current_user.id, file: params[:upload_file]

    if @attachment.save
      render json: {
        success: true,
        file_path: @attachment.file.url
      }
    else
      render json: {
        success: false,
        msg: @attachment.errors.full_messages
      }, status: :unprocessible_entity
    end
  end

  def create
    @attachment = Attachment.new params[:attachment]
  	# @attachment[:price] = params[:price]
    topic.attachments << @attachments
  end

  def set_price
    if params[:price] =~ /\d+/
      @attachment[:price] = params[:price].to_i
    else
      render :json => {:error => '请输入数字'}
    end
  end


  protected
  def check_owner
  	unless logged_in? and topic.owner == current_user
	  	render :text => 'You cannot manipulate attachment'
  	end
  end

  def find_group
    @group ||= Group.find_by_alias! params[:group_id]
  end

  def find_topic
    topic ||= @group.topics.find params[:topic_id]
  end

  def resource
    @attachment ||= Attachment.find params[:id]
  end

end
