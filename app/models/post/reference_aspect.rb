# coding: utf-8
module ReferenceAspect
  extend ActiveSupport::Concern
  included do
    has_many :references
    has_many :referenced_topics, :through => :references
    belongs_to :sources
  end

  module ClassMethods
    def detect_references

    end
  end

  def detect_refereneces
    self.class.detect_refereneces(content).each do |slug, title|
    end
  end


end