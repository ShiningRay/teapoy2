# encoding: utf-8
class GroupsController < ApplicationController
  rescue_from  User::NotAuthorized ,:with => :group_is_secret
  before_filter :login_required #, :only => [:new, :create, :join, :quit,:allow_join,:reject_join,:judge_articles,:edit]
  #theme :select_theme
  #load_and_authorize_resource
  caches_page :sitemap_index
  # caches_page_for_anonymous :index, :show
  before_action :find_group, only: %i(update destroy join quit edit)
  def index
    respond_to do |format|
      format.html {
        #@groups = Group.public_groups.not_pending.where(:hide => 0).order('feature desc, score desc').includes(:owner).page(params[:page])
        render :layout => 'onecolumn'
      }
      format.any(:mobile, :wml) {
        #slide第一个，我们做过的那些梦，精彩自拍，水库，当时我就震惊了
        first =  [254,251,1,32]
        #slide第二个 今天吃了什么，音乐直通车,微视频,碎碎念
        second = [275,34,66,264]
        #slide第三个，what a funcking day，上班那些事，情感，狗血生活
        third = [77,108,222,18]
        # 晚安，夜半鬼话，学生党，心理测试
        forth = [107,12,145,265]
        recommented_groups = first
        hour = Time.now.hour
        case hour
        when 11..14
          recommented_groups = second
        when 14..22
          recommented_groups = third
        when 22..24
          recommented_groups = forth
        end
        @recommented_groups = Group.where(:id.in => recommented_groups)
      }
      format.json {
        @groups = Group.page(params[:page]).order("feature DESC , score DESC").includes(:owner)
        render :json => {:num_pages => @groups.num_pages, :groups => @groups}
      }
    end
  end

  def sitemap_index
    @groups = Group.where(:private => false)
  end

  def edit
    @group = Group.find_by_alias!(params[:id])
    return render :text=>"只有小组组长才能编辑" unless current_user.own_group?(@group)
  end

  def show
    @list_view = true
    return redirect_to( '/groups/all/articles' )if params[:id] == 'all'
    @group = Group.wrap!(params[:id])
    @page = Group.meta_group.articles.find_by_cached_slug(@group.alias)
    @show_group = true

    authorize @group

    #raise User::NotAuthorized if @group.private and (not logged_in? or !current_user.is_member_of?(@group) )
    #return render :action => 'forbidden', :status => 403 if !logged_in? || !current_user.is_member_of?(@group)
    return render :template=>"/groups/pending" if @group.status == "pending"
    respond_to do |format|
      format.any( :html, :wml)
      format.any(:js, :json) do
        render :json => @group
      end
    end
  end

  def update
    @group = Group.find_by_alias!(params[:id])
    update! do |format|
      format.any(:html, :mobile, :wml){
        flash[:notice] = '更新成功'
        redirect_to edit_group_path(@group)
      }
    end
  end

  def search
    if params[:search]
      reg = Regexp.new(params[:search])
      @groups = Group.where(:name => reg).or(:description => reg).not_pending.page(params[:page])
      @in_search_page = true
      render :index, :layout => 'onecolumn'
    else
      redirect_to groups_path
    end
  end

  def create

    @group = build_resource

    if current_user.is_admin? and !params[:user_id].blank?
      @group.owner = User.wrap params[:user_id]
    else
      @group.owner = current_user
    end
    params[:tag].gsub("，",",")
    params[:tag].split(ActsAsTaggableOn::TagList.delimiter).each do |tag|
      params[:tag].delete!(tag)  unless tag =~  Regexp.new(ActsAsTaggableOn::Tag.all.collect{|t| t.name}.join('|'))
    end
    params[:tag].split(",").drop_while{|str| str.blank?}
    params[:tag] =  params[:tag].split(",")[0..4]
    @group.tag_list = params[:tag] unless params[:tag].blank?
    @group.status = "pending"
    if @group.valid?
      if  (current_user.credit >= 10000 && params[:use_balance] == "yes" ) || current_user.is_admin?
        t = @group.transaction do
            current_user.spend_credit(10000, 'groups#create') unless current_user.is_admin?
          @group.status = "open"
          @group.save!
        end
      else
        @group.save!
        Message.send_message(135, 78, "有新的小组等待审核")
      end
      redirect_to (@group)
    else
      render :new
    end
  end

  def join
    return if @group.status == "pending"
    ms = current_user.join_group(@group)
    flash[:notice]= I18n.t 'groups.user_joined', :group => @group.name
    flash[:notice]= I18n.t 'groups.waiting_approve' if @group.preferred_membership_need_approval?
    respond_with @group
  end

  def quit
    return if @group.status == "pending"
    current_user.quit_group(@group)
    flash[:notice]= I18n.t 'groups.user_quited', :group => @group.name
    respond_with @group
  end

  def allow_join
    g = Group.find_by_alias!(params[:group_id])
    if current_user.own_group?(g)
      u = User.find_by_login params[:user_id]
      Membership.find_by_group_id_and_user_id(g,u).update_attributes!(:role=>"subscriber")
      u.subscribe(g) unless u.has_subscribed?(g)
      Message.create!(:owner_id=>current_user.id, :sender_id => current_user.id, :recipient_id=> u.id,:content=>"小组:#{g.name}的组长已经通过了您的进组申请",:read => true)
      Message.create!(:owner_id=>u.id, :sender_id => current_user.id, :recipient_id=> u.id,:content=>"小组:#{g.name}的组长已经通过了您的进组申请")
      flash[:notice] = "已经将该用户加入此小组"
    else
      flash[:notice] = "对不起，只有小组长才有这个权利"
    end
    redirect_to "/#{g.alias}/users"
  end

  def reject_join
    g = Group.find_by_alias!(params[:group_id])
    if current_user.own_group?(g)
      u = User.find_by_login params[:user_id]
      Membership.find_by_group_id_and_user_id(g,u).try(:destroy)
      #  if g.private or g.preferred_only_member_can_view?
      u.unsubscribe(g) if u.has_subscribed?(g)
      Message.create!(:owner_id=>current_user.id, :sender_id => current_user.id, :recipient_id=> u.id,:content=>"该小组组长已经把您从小组：#{g.name}中踢出去了。",:read => true)
      Message.create!(:owner_id=>u.id, :sender_id => current_user.id, :recipient_id=> u.id,:content=>"该小组组长已经把您从小组：#{g.name}中踢出去了。")
      flash[:notice] = "已经将该用户踢出该小组"
    else
      flash[:notice] = "对不起，只有小组长才有这个权利"
    end
    redirect_to "/#{g.alias}/users"
  end


  def invite
    @group = Group.find_by_alias!(params[:id])
    unless current_user.is_member_of?(@group)
      flash[:error] = 'You can not invite others to those groups you are not a member of'
      return
    end
    if params[:user_ids]
      #users = current_user.friends.find params[:user_ids]
      users = User.find params[:user_ids]
      users.each do |user|
        #@key = InvitationCode.generate
        Notification.send_to user, :invite, group, current_user
      end
      return redirect_to(@group)
    else
      @users = User.where(:state => 'active')
    end
  end
protected
  def render(*args)
    if @articles && ! @articles.empty? && logged_in?
      #current_user.ratings_for @articles
      current_user.roles
      Article.send(:preload_associations, @articles, ['score'])
    end
    super(*args)
  end

  def group_is_secret
    flash[:notice] =  "这个是私秘小组"
    render :action=>"forbidden",:controller=>"groups"
  end

  def resource
    @group ||= Group.find_by_alias params[:id]
  end

  alias group resource
  alias find_group group

  def build_resource
    @group = Group.new
  end
end
