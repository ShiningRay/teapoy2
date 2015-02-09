# coding: utf-8
class CommentMailer < ActionMailer::Base
  default :from => 'admin@bling0.com'
  layout "mail"
end
