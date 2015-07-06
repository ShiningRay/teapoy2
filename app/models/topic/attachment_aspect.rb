# coding: utf-8
module Topic::AttachmentAspect
	extend ActiveSupport::Concern

	def attachments
		top_post.attachments
	end

end
