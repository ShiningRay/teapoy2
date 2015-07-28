# coding: utf-8
class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :check_user

  has_scope :after, only: :index
  has_scope :before, only: :index
  has_scope :limit, default: 20, only: :index

  #load_and_authorize_resource :message, :through => :current_user
  # GET /messages
  # GET /messages.xml
  def index
    @messages = apply_scopes(scope.messages)
    @messages.read!
    respond_to do |format|
      format.html {
        render layout: false if request.xhr?
      }
      format.json
      format.js
    end
  end

  def inbox
    @messages = current_user.inbox_messages.page(params[:page])
    @messages.each do |msg|
      unless msg.read
        msg.read = true
        msg.save!
      end
    end
  end

  def outbox
    @messages = current_user.outbox_messages.page(params[:page])
  end

  def status

  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = current_user.messages.find(params[:id])
    respond_to do |format|
      format.any(:html, :wml)
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new
    if params[:id]
      @user = User.find params[:id]
      if not @user
        flash[:error] = 'Cannot find that user'
        return redirect_to :back
      end
    end
    @message.recipient = @user
  end

#  # GET /messages/1/edit
#  def edit
#    @message = Message.find(params[:id])
#  end

  # POST /messages
  # POST /messages.xml
  def create
    message = params.require(:message).permit(:recipient_id, :content)

    message[:sender_id] = message[:owner_id] = current_user.id
    @out_message = Message.new(message)
    @out_message.read = true
    message[:owner_id] = message[:recipient_id].to_i
    @message = @in_message = Message.new(message)
    @in_message.read = false
    @out_message.save!

    @in_message.save!
    respond_to do |format|
      format.any(:html, :wml) {
        redirect_to messages_path
      }
      format.js { @message = @out_message }
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
#  def update
#    @message = Message.find(params[:id])
#
#    respond_to do |format|
#      if @message.update_attributes(params[:message])
#        flash[:notice] = 'Message was successfully updated.'
#        format.html { redirect_to(@message) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.any(:html, :wml) {
        redirect_to messages_path
      }
    end
  end
  protected
  def check_user
    @user = current_user
  end

  def resource
    @message ||= scope.find params[:id]
  end

  def conversation
    @conversation ||= current_user.conversations.find params[:conversation_id]
  end

  def scope
    if params[:conversation_id]
      @scope ||= conversation
    else
      @scope ||= current_user
    end
  end
end
