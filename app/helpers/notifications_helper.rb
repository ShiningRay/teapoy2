# coding: utf-8
module NotificationsHelper
  def render_notification(n)
    render :partial =>  "notifications/#{n.scope}", :object => n,
           :locals => { :notification => n, n.subject_type.underscore.to_sym => n.subject }

  end
end

