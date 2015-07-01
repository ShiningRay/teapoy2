# coding: utf-8
module Topic::AttachmentAspect
	extend ActiveSupport::Concern

	def min_floor
		@min_floor ||= new_record? ? 0 : posts.minimum(:floor).to_i
	end

	def min_floor=(new_min_floor)
		@min_floor = new_min_floor
	end

	def assign_attachment_floor(rec)
		unless rec.floor
			self.min_floor -= 1
			rec.floor = self.min_floor
		end
    rec.parent_id ||= 0
		rec.user_id ||= self.user_id
		rec.group_id ||= self.group_id
	end

	def attachments
		posts.where(:floor.lt => 0)
	end

	included do
		#has_many :attachments, :class_name => 'Post'#, :conditions => 'posts.floor < 0', :inverse_of => :topic, :before_add => :assign_attachment_floor
		#has_many :attachments, :class_name => 'Post', :inverse_of => :topic, :before_add => :assign_attachment_floor

		# accepts_nested_attributes_for :attachments
	end
end
