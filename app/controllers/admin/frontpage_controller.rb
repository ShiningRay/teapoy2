# coding: utf-8
class Admin::FrontpageController < Admin::BaseController
	def index
		@items = Inbox.guest.hottest.page(params[:page])
	end
	def deliver
		topic = Topic.find params[:topic_id]
		Inbox.frontpage_deliver topic.top_post, -100
		head :ok
	end
end