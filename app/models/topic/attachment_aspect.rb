# coding: utf-8
module Topic::AttachmentAspect
	extend ActiveSupport::Concern

	def attachments
		top_post.attachments
	end
  def attachment_ids=(new_ids)
    @attachment_ids = new_ids
  end
end
