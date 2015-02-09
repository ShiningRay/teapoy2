# encoding: utf-8
# This model stores the global configuration of the website
class Setting < ActiveRecord::Base
  serialize :value
  class << self
    def [] index
      index = index.to_s
      Rails.cache.fetch("Setting.#{index}") do
        record = find_by_key index
        record.value if record
      end
    end

    def []= index, value
      find_or_create_by_key(:key => index).update_attribute(:value, value)
      Rails.cache.write("Setting.#{index}", value)
    end

    def method_missing(selector, *args, &block)
      if selector.to_s =~ /(\w+)=$/
        self[$1]=args[0]
      elsif args.size == 0
        self[selector]
      else
        super
      end
    end
  end
end
