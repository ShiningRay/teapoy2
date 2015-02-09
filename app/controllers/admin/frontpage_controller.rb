# coding: utf-8
class Admin::FrontpageController < Admin::BaseController
	def index
		@items = Inbox.guest.hottest.page(params[:page])
	end
	def deliver
		@article = Article.find params[:article_id]
		Inbox.frontpage_deliver @article.top_post, -100
		head :ok
	end
end