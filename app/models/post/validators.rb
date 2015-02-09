# coding: utf-8
module Post::Validators
  extend ActiveSupport::Concern
	module ClassMethods
		def acts_as_top_post_only
      validates_each :parent_id do |model, attr, value|
        model.errors.add(attr, 'must be top post in article') unless value.nil?
      end
    end

    def acts_as_children_only
    	validates_each :parent_id do |model, attr, value|
    		model.errors.add(attr, 'must be children in article') if value.nil?
    	end
    end

    def acts_as_unique_child
      validates  :user_id, :uniqueness  => {:scope => :article_id}
    end

    def validates_parent_of(clazz)
      clazz = clazz.constantize unless clazz.is_a?(Class)
      validates_each :parent_id do |model, attr, value|
        model.errors.add(attr, "must be of #{clazz.inspect}") unless model.parent.is_a?(clazz)
      end
    end
	end
end
