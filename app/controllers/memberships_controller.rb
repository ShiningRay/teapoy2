# coding: utf-8
class MembershipsController < ApplicationController

  def index
    @group = Group.wrap params[:group_id]
    return show_404 unless @group
    @memberships = @group.memberships.all
    respond_with @memberships
  end
end

