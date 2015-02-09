# -*- coding: utf-8 -*-
class Users::ArticlesController < ArticlesController
  def index
    if params[:user_id]
      @user = User.find_by_login!(params[:user_id])
      return show_404 unless @user.id > 0
      scope = @user.articles.signed.where(:status => :publish)
      # seo_for_user
    end

    if params[:group_id]
      find_group
      return render :text => '', :status => :not_found unless @group
      raise User::NotAuthorized if @group and @group.private and (not logged_in? or !current_user.is_member_of?(@group))
      return render :template => "/groups/pending" if @group.status == "pending"

      scope = scope.where(:group_id => @group.id)
    end
    @show_user_sidebar = true
    @hide_group_nav = true
    scope = scope.public_articles.before
    params[:limit] ||= 'day' if params[:order] == 'hottest'

    if i = KEYS.index(params[:limit])
      params[:order] = 'hottest'
      @limit = params[:limit]
      @next_limit = KEYS[i+1]
      scope = scope.hottest
      scope = scope.where(:created_at.gt => DateRanges[@limit].ago) if @limit != 'all'
    else
      params[:order] = 'latest'
      scope = scope.before.latest
    end
    @articles = scope.includes(:top_post, :group).page(params[:page])
    @show_group = !@group
    @list_view = true
    if logged_in?
      @top_posts = @articles.collect{|a|a.top_post}
    end
    @articles.reject!{|a| a.top_post.nil? or a.top_post.status == 'deleted' }

    respond_to do |format|
      format.any(:html,:wml,:mobile){
       return render :template=>"/articles/index"
      }
      format.json do
        render :json => {
          :articles => @articles,
          :num_pages => @articles.num_pages
        }
      end
      format.xml {
        prepend_view_path File.join(Rails.root, 'app', 'views', 'feeds')
        render :text => '<?xml version="1.0" encoding="UTF-8"?><rss></rss>', :status => :not_found if @articles.empty?
      }
      format.atom
    end
  end
end
