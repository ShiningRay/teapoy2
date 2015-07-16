# coding: utf-8
class TagsController < ApplicationController

  def show
    @tag = params[:id]
    @groups = Group.tagged_with(params[:id]).public_groups.not_pending.order(:feature => :desc).page(params[:page])
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
        @tags = @group.public_topics.cached_tag_clouds
        render :json => @tags
      }
    end
  end

  def hottest
    @tag = params[:id]
    group_ids = Group.tagged_with(params[:id]).select('groups.id').collect(&:id)
    params[:limit] ||= 'day'
    parent = Topic.where(:group_id => group_ids)

    i = TopicsController::KEYS.index(params[:limit])
    if i
      @limit = params[:limit]
      @next_limit = TopicsController::KEYS[i+1]
    else
      @limit = 'day'
    end

    @show_group = !@group
    @list_view = true
    topics = parent.public_topics.before.includes(:top_post, :user, :group).order('topics.score desc').page(params[:page])
    topics = topics.where('created_at >= ?', TopicsController::DateRanges[@limit].ago) if @limit != 'all'
    respond_to do |format|
      format.any(:html, :mobile ){
        render :template => 'topics/index'
      }
    end
  end

  def latest
    @tag = params[:id]
    group_ids = Group.tagged_with(params[:id]).select('groups.id').collect(&:id)
    @show_group = !@group
    @list_view = true
    topics = Topic.where(:group_id => group_ids).public_topics.before.latest.includes(:top_post, :user, :group).page(params[:page])
    respond_to do |format|
      format.any(:html, :mobile){
        render :template => 'topics/index'
      }
    end
  end

  def tag
    opt = Topic.find_options_for_find_tagged_with params[:tag],
      :select => 'topics.*',
      :order => 'topics.id DESC'
    opt[:page] = params[:page]
    topics = @group.topics.public_topics.paginate opt
    #@group.public_topics.paginate :page => params[:page], :conditions => ['cached_tag_list LIKE ?', "%#{params[:tag]}%"]
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

