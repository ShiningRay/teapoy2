# coding: utf-8
class Admin::CommentsController < Admin::BaseController
  #cache_sweeper :comment_sweeper, :only => [ :set_status,  :batch_set_status]

  def index
    @status = params[:status] || 'pending'
    @statuses = Comment::STATUSES
    sql = <<SQL
SELECT topics . *
FROM topics
LEFT JOIN comments ON topics.id = comments.topic_id
WHERE comments.status = ?
GROUP BY comments.topic_id
SQL
    topics = Topic.paginate_by_sql [sql , @status], :page => params[:page]
    @comments = {}
    topics.each do |a|
      @comments[a.id] = a.comments.find :all, :conditions => {:status => @status}
    end
  end

  def new
    topic = Topic.find params[:topic_id]
    @comment = topic.comments.new
    render :layout => false
  end

  def create
    topic = Topic.find params[:comment][:topic_id]
    @comment = topic.comments.build params[:comment]
    @comment.user = current_user
    @comment.ip = request.remote_ip
    @comment.status = 'publish'
    @comment.save!
    if request.xhr?
      render :text => ''
    else
      redirect_to :back
    end
  end

  def set_status
    @comment = Comment.find params[:id]
    @comment.status = params[:status]
    @comment.save!
    redirect_to :back
#  rescue
#    redirect_to :back
  end

  def batch_set_status
    params[:status] ||= 'publish'
    if params[:id]
      Comment.find(params[:id]).each do |comment|
        comment.status = params[:status]
        comment.save!
      end
    end
    if params[:delete_else]
      Comment.find(params[:delete_else].split(',').collect{|i| i.to_i if i.is_a? String }).each do |a|
        a.destroy
      end
    end
    redirect_to :back
  end

  def destroy
    Comment.delete(params[:id])
    if request.xhr?
      render :nothing => true
    else
      redirect_to :back
    end
  end
end
