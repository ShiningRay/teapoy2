# coding: utf-8
module Topic::ScheduleAspect
  extend ActiveSupport::Concern
  included do
    before_validation do
      self.status = 'future' if !created_at.blank? and created_at > Time.now and status == 'publish'
    end
  end
  module ClassMethods
    def schedule_future_topics
      unscoped.where(status: 'future').where(:created_at.lte => Time.now).each do |topic|
        topic.no_log = true
        topic.publish!
        topic.save!
      end
    end
  end
end