# coding: utf-8
module ActsAsSoftDelete
  extend ActiveSupport::Concern

  def destroy
    run_callbacks(:destroy) do
      destroy_associations
      if persisted?
        ActiveRecord::IdentityMap.remove(self) if ActiveRecord::IdentityMap.enabled?
      end
      self.status='deleted'
      self.class.delete_all(:id => self.id)
      @destroyed = true
      #freeze
    end
  end

  def destroyed?
    @destroyed || status == 'deleted'
  end

  module ClassMethods
    def delete_all(conditions=nil)
      update_all({:status => 'deleted'}, conditions)
    end
  end
end