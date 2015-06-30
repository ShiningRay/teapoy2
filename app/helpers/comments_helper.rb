# coding: utf-8
module CommentsHelper
  def comment_form(article=topic)
    render :partial => 'comments/form', :locals => {:article => article}
  end
  def render_comments(comments=@comments)
  	render :partial => 'comments/comment', :collection => comments
  end

  def render_comment(comment=@comments, locals = nil)
  	render :partial => 'comments/comment', :object => comment, :locals => locals
  end
end
