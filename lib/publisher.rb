# coding: utf-8
module Publisher
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions#, :as => :publication, :dependent => :delete_all
    has_many :subscribers#, :through => :subscriptions, :source => :subscriber
  end

  module ClassMethods
    # set hook for publications
    def provide(*clazz, &block)
      publisher_class = self
      association_name = publisher_class.name.underscore
      block ||= ->(rec) { rec.send(association_name).notify(rec)}

      # clazz.each do |c|
      #   c.after_create &block
      # end
    end
  end

  def notify(rec=nil)
    t = quote_value(Time.now)
    s = rec && rec.respond_to?(:user_id) ? subscriptions.where('subscriber_id != ?', rec.user_id) : subscriptions
    s.update_all("`updated_at` = #{t} , `unread_count`=`unread_count`+1")#(:updated_at => Time.now)
    #subscriptions.each do |s|
    #  s.increment! :unread_count
    #end
  end
end
