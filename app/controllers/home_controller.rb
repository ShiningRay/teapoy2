# encoding: utf-8
class HomeController < ApplicationController
  layout 'onecolumn'
  before_filter :send_user, :only => :index

  caches_action :index, :cache_path => {:revision => $revision, :only_path => true}
  def send_user
    return redirect_to(hottest_all_articles_path) if in_mobile_view?
    return redirect_to(:controller => 'my', :action => 'latest') if logged_in?
  end
  protected :send_user
  def index
    respond_to do |format|
      format.html do
        render :layout => false
      end
      format.any(:mobile, :wml)
    end
  end

  def hottest
    @items = Inbox.guest.includes(:article => [:user, :top_post, :group]).order('score desc').page(params[:page])
    @articles = @items.collect{|i|i.article}
    @articles.compact!
    render :latest
  end

  def latest
    @items = Inbox.guest.joins(:article).includes(:article => [:user, :top_post, :group]).order('articles.created_at desc').page(params[:page])
    @articles = @items.collect{|i|i.article}
    @articles.compact!
  end
end
