# coding: utf-8
module Article::ChangeLogAspect
	extend ActiveSupport::Concern
	module ClassMethods

	end
	#module InstanceMethods
		def save_change_log
			return if no_log
			c = ::ChangeLog.new
			c.parent_id = 0
			c.changed_fields = changes.dup
			#Rails.logger.debug c.changed_fields
			c.changed_fields.delete(:updated_at)
			c.changed_fields.delete(:created_at)
			if operator
				c.user_id = operator.is_a?(User) ? operator.id : operator
			else
				c.user_id = user_id
			end
			#c.user_id =  ? user_id : operator
			posts << c
		end
	#end

	included do
		attr_accessor :operator, :no_log
		#before_update :save_change_log, :if => :changed?
	end
end
