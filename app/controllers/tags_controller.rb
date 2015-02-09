# coding: utf-8
class TagsController < ApplicationController

  def show
    @tag = params[:id]
    @groups = Group.tagged_with(params[:id]).public_groups.not_pending.order_by(:feature => :desc).page(params[:page])
    respond_to do |format|
      format.any(:html, :wml) {
        render :template=>'groups/index'
      }
    end
  end

  def tags
    respond_to do |format|
      format.html
      format.mobile
      format.js {
        @tags = @group.public_articles.cached_tag_clouds
        render :json => @tags
      }
    end
  end

  def hottest
    @tag = params[:id]
    group_ids = Group.tagged_with(params[:id]).select('groups.id').collect(&:id)
    params[:limit] ||= 'day'
    parent = Article.where(:group_id => group_ids)

    i = ArticlesController::KEYS.index(params[:limit])
    if i
      @limit = params[:limit]
      @next_limit = ArticlesController::KEYS[i+1]
    else
      @limit = 'day'
    end

    @show_group = !@group
    @list_view = true
    @articles = parent.public_articles.before.includes(:top_post, :user, :group).order('articles.score desc').page(params[:page])
    @articles = @articles.where('created_at >= ?', ArticlesController::DateRanges[@limit].ago) if @limit != 'all'
    respond_to do |format|
      format.any(:html, :mobile ){
        render :template => 'articles/index'
      }
    end
  end

  def latest
    @tag = params[:id]
    group_ids = Group.tagged_with(params[:id]).select('groups.id').collect(&:id)
    @show_group = !@group
    @list_view = true
    @articles = Article.where(:group_id => group_ids).public_articles.before.latest.includes(:top_post, :user, :group).page(params[:page])
    respond_to do |format|
      format.any(:html, :mobile){
        render :template => 'articles/index'
      }
    end
  end

  def tag
    opt = Article.find_options_for_find_tagged_with params[:tag],
      :select => 'articles.*',
      :order => 'articles.id DESC'
    opt[:page] = params[:page]
    @articles = @group.articles.public_articles.paginate opt
    #@group.public_articles.paginate :page => params[:page], :conditions => ['cached_tag_list LIKE ?', "%#{params[:tag]}%"]
    @current_tag = params[:tag]
    render :archives
  rescue ArgumentError
    show_404 params[:tag]
  end

  def edit
    if request.post?
      params[:tags].each_pair do |id, tags|
        tags.gsub!("，",",")
        tags.strip!
        g = Group.find id
        g.tag_list = tags
        g.save!
      end
    end
    @groups = Group.all
  end
end

