# attachments_aspect.rb

module Post::AttachmentsAspect
  extend ActiveSupport::Concern
  included do
    has_many :attachments
    alias_method_chain :attachment_ids=, :save_for_associate
    after_create :create_association_for_attachments
  end

  def attachment_ids_with_save_for_associate=(new_ids)
    new_ids = Array.new(new_ids)
    if new_record?
      @attachment_ids = Attachment.where(:id => new_ids).where(post_id: nil).pluck(:id)
    else
      self.attachment_ids_without_save_for_associate=new_ids
    end
  end

  def create_association_for_attachments
    if @attachment_ids.present?
      self.attachment_ids_without_save_for_associate = @attachment_ids
    end
  end


end