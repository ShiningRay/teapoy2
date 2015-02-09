# coding: utf-8
module Article::ScheduleAspect
  extend ActiveSupport::Concern
  included do
    before_validation do
      self.status = 'future' if !created_at.blank? and created_at > Time.now and status == 'publish'
    end
  end
  module ClassMethods
    def schedule_future_articles
      unscoped.where(status: 'future').where(:created_at.lte => Time.now).each do |article|
        article.no_log = true
        article.publish!
        article.save!
      end
    end
  end
end