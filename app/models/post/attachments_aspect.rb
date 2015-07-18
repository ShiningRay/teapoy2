# attachments_aspect.rb

module Post::AttachmentsAspect
  extend ActiveSupport::Concern
  included do
    has_many :attachments
  end

  # only associate attachment without post_id
  def attachment_ids=(new_ids)
    super Attachment.where(:id => new_ids).where(post_id: nil).pluck(:id)
  end
end