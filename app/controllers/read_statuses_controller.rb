class ReadStatusesController < ApplicationController
  before_filter :login_required
  def create
    #Article
    current_user.mark_as_read(params[:article_id], params[:floor])
    respond_to do |format|
      format.json {
        render :status => :created
      }
    end
  end
  protected
    def begin_of_association_chain
      current_user
    end

    def resource
      @read_status ||= begin_of_association_chain.read_statuses.find params[:id]
    end
end
