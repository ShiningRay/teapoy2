# encoding: utf-8
class HomeController < ApplicationController
  layout 'onecolumn'
  before_filter :send_user, :only => :index

  caches_action :index, :cache_path => {:revision => $revision, :only_path => true}
  def send_user
    return redirect_to(hottest_all_topics_path) if in_mobile_view?
    return redirect_to(:controller => 'my', :action => 'latest') if logged_in?
  end
  protected :send_user
  def index
    respond_to do |format|
      format.html do
        render :layout => false
      end
      format.wml
    end
  end

  def hottest
    @items = Inbox.guest.includes(:topic => [:user, :top_post, :group]).order('score desc').page(params[:page])
    topics = @items.collect{|i|i.topic}
    topics.compact!
    render :latest
  end

  def latest
    @items = Inbox.guest.joins(:topic).includes(:topic => [:user, :top_post, :group]).order('topics.created_at desc').page(params[:page])
    topics = @items.collect{|i|i.topic}
    topics.compact!
  end
end
