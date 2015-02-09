# encoding: utf-8
module AntiSpam
  extend ActiveSupport::Concern

  included do
    #base.class_eval do
      #before_validation :filter_keywords
      #before_validation :check_spam
    #end
    #base.extend(ClassMethods)
  end
  module ClassMethods
    # options
    # :only => <events>
    # events are before_save, before_create
    def harmonize(*fields)
      return unless Setting.replacelist_pattern
      opt = fields.extract_options!
      opt.reverse_merge! :at => :before_save
      at = opt[:at]
      send( at ) do |record|
        fields.each do |field|
          record[field] = filter_keywords(record[field]) if record.send "#{field}_changed?" and !(record[field].blank?)
        end
      end
    end
    def check_spam(*fields, &block)
      opt = fields.extract_options!
      opt.reverse_merge!(:at => :before_validation)
      at = opt.delete(:at)
      send( at ) do |record|
        fields.each do |field|
          check_spam field, &block
        end
      end
    end
  end

  def check_spam(field)
    if new_record? and blacklist_pattern and read_attribute(field) =~ blacklist_pattern
      if block_given?
        yield self
      else
        self.status = 'spam'
      end
    end
  end

  def filter_keywords(content)
    content.gsub(replacelist_pattern) do
      Setting['replacelist'][$&].to_s.dup.force_encoding('utf-8')
    end if replacelist_pattern
  end

  protected
  def replacelist_pattern
    @replacelist_pattern ||= Regexp.union(Setting['replacelist'].keys) if Setting['replacelist']
  end

  def blacklist_pattern
    @blacklist_pattern ||= Regexp.union(Setting['blacklist']) if Setting['blacklist_pattern']
  end
end
