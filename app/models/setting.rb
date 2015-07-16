# encoding: utf-8
# == Schema Information
#
# Table name: settings
#
#  id    :integer          not null, primary key
#  key   :string(255)      not null
#  value :text(65535)      not null
#
# Indexes
#
#  index_settings_on_key  (key) UNIQUE
#

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
      find_or_initialize_by(:key => index).update_attribute(:value, value)
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
