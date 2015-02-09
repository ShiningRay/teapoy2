# coding: utf-8
class Admin::GroupsController < Admin::BaseController
  # GET /keywords
  # GET /keywords.xml
  def index
    if params[:cond]
      @groups = Group.where(params[:cond]).order("id DESC")
    elsif params[:search]
      @groups = Group.where(name: /#{params[:search]}/).page(params[:page])
    else
      @groups = Group
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
      format.json  {
        json_group =  Group.collect{|c| {"name"=>c.name,"url"=>c.name.to_url,"id"=>c.id}}
        render :json => @groups.to_json
      }
    end
  end

  # GET /keywords/1
  # GET /keywords/1.xml
  def show
    @group = Group.find_by_alias params[:id]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /keywords/new
  # GET /keywords/new.xml
  def new

    @group = Group.new

    respond_to do |format|
      format.html { render :edit}
      format.xml  { render :xml => @group }
    end
  end

  # GET /keywords/1/edit
  def edit
    @group = Group.find_by_alias(params[:id])
  end

  # POST /keywords
  # POST /keywords.xml
  def create
    unless params[:group][:parent_id].blank?
      parent = Group.find_by_id params[:group][:parent_id]
    end

    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        @group.move_to_child_of parent if parent
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to admin_groups_path }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :edit }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /keywords/1
  # PUT /keywords/1.xml
  def update
    @group = Group.find_by_alias params[:id]
    parent_id = params[:group][:parent_id]
#    if parent_id.blank?
#      params[:group].delete :parent_id
#      @group.move_to_root
#    else
#      begin
#        @group.move_to_child_of Group.find(parent_id.to_i)
#      rescue
#        flash[:error] = 'Cannot move into that group'
#        return render(:template => 'admin/categories/edit')
#      end
#    end
    user = User.wrap(params[:group][:owner_id])
    user.join_group(@group)

    if @group.update_attributes group_params
      redirect_to edit_admin_group_path(@group)
    else
      render :edit
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.xml
  def destroy
    @group = Group.find(params[:id])
    if @group.id > 0
      @group.destroy
    else
      flash[:error] = 'You cannot destroy meta groups'
    end

    respond_to do |format|
      format.html { redirect_to(admin_groups_url) }
      format.xml  { head :ok }
    end
  end

  def moveup
    @group = Group.find params[:id]
    @group.move_left if @group.left_sibling
    redirect_to admin_groups_path
  end

  def movedown
    @group = Group.find params[:id]
    @group.move_right if @group.right_sibling
    redirect_to admin_groups_path
  end
  def merge_with
    @from = Group.find params[:from_id]
    @to = Group.find params[:to_id]
    @from.merge_with(@to)
    redirect_to admin_groups_path
  end

  def group_params
    params.require(:group).permit!
  end
end
