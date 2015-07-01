# coding: utf-8
module CommentsHelper
  def comment_form(topic=@topic)
    render :partial => 'comments/form', :locals => {:topic => topic}
  end
  def render_comments(comments=@comments)
  	render :partial => 'comments/comment', :collection => comments
  end

  def render_comment(comment=@comments, locals = nil)
  	render :partial => 'comments/comment', :object => comment, :locals => locals
  end
end
