# coding: utf-8
class NotificationsController < ApplicationController
  before_filter :login_required, :except => :show
  #layout 'users'
  # GET /notifications
  # GET /notifications.xml
  respond_to :html, :mobile, :wml, :json

  def index
    @notifications = current_user.notifications.latest
    if params[:read]
      @notifications = @notifications.read
    else
      @notifications = @notifications.unread
    end
    @unread_notification_count = @notifications.count
    @notifications = @notifications.page params[:page]
    #@notifications = @notifications.where(:updated_at.gt => params[:after]) if params[:after]
    @user = current_user

    respond_to do |format|
      format.any(:html, :mobile, :wml) {
        render :layout => false if request.xhr?
      }
      format.json {
        notifications_json = @notifications.as_json
        notifications_json.each do |c|

      end
        render :json => notifications_json
      }
    end
  end


  # GET /notifications/1
  # GET /notifications/1.xml
  def show
    @notification = Notification.find(params[:id])
    @notification.read!
    location = case @notification.scope.to_s
    when 'reply', 'mention'
      article = @notification.subject
      article_path(article.group, article)
    when 'new_follower'
      user_path(@notification.key)
    when 'delete_comment'
      :back
    end
    unless location == :back
      redirect_to location, :location => 301
    else
      redirect_to location
    end
  rescue Mongoid::Errors::DocumentNotFound
    show_404
  end

  def dismiss
    params[:id].gsub!(/notification_/, '')
    @notification = Notification.find(params[:id])
    @notification.read!
    respond_to do |format|
      format.json { head :ok }
    end
  end

  # GET /notifications/new
  # GET /notifications/new.xml
#  def new
#    @notification = Notification.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @notification }
#    end
#  end

  # GET /notifications/1/edit
#  def edit
#    @notification = Notification.find(params[:id])
#  end

  # POST /notifications
  # POST /notifications.xml
#  def create
#    @notification = Notification.new(params[:notification])
#
#    respond_to do |format|
#      if @notification.save
#        flash[:notice] = 'Notification was successfully created.'
#        format.html { redirect_to(@notification) }
#        format.xml  { render :xml => @notification, :status => :created, :location => @notification }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /notifications/1
#  # PUT /notifications/1.xml
#  def update
#    @notification = Notification.find(params[:id])
#
#    respond_to do |format|
#      if @notification.update_attributes(params[:notification])
#        flash[:notice] = 'Notification was successfully updated.'
#        format.html { redirect_to(@notification) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.xml  { head :ok }
    end
  end
  # delete /notifications/
  def clear
    current_user.notifications.delete_all
    respond_to do |format|
      format.html { redirect_to(notifications_url) }
    end
  end

  def clear_all
    current_user.notifications.all.each { |n|
        n.read!
    }
    @unread_notification_count = current_user.notifications.unread.count
    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.mobile { redirect_to(notifications_url) }
      format.wml { redirect_to(notifications_url) }
      format.js
    end
  end

  def ignore
    @notification = Notification.find(params[:id])
    @notification.read!
    @unread_notification_count = current_user.notifications.unread.count
    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.mobile { redirect_to(notifications_url) }
      format.wml { redirect_to(notifications_url) }
      format.js
    end
  end
end
