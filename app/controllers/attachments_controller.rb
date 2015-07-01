# coding: utf-8
class AttachmentsController < ApplicationController
  before_action :find_group
  before_action :find_topic
  before_action :resource, only: %i(show set_price)

  def index

  end

  def show

  end

  def create
    @attachment = Post.new params[:attachment]
  	@attachment[:price] = params[:price]
    topic.attachments << @attachments
  end

  def set_price
    if params[:price] =~ /\d+/
      @attachment[:price] = params[:price].to_i
    else
      render :json => {:error => '请输入数字'}
    end
  end

  before_filter :check_owner
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
