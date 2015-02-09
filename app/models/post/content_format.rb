# coding: utf-8
module Post::ContentFormat
  extend ActiveSupport::Concern
  included do
    #meta_methods :format
  end

  module ClassMethods

  end

  def format
    @format ||= (self[:format] || :plain).to_sym
  end

  def format=(new_format)
    self[:format] = @format = new_format.to_sym
  end
end
