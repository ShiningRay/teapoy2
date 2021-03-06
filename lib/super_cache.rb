# coding: utf-8
require 'uri'
require 'fileutils'
# for static-caching the generated html pages

module SuperCache
  def self.included(base)
    base.extend(ClassMethods)
    #base.class_attributes :super_cache_options
  end

  module ClassMethods
    def super_caches_page(*pages)
      return unless perform_caching
      options = pages.extract_options!
      options[:only] = (Array(options[:only]) + pages).flatten
      #self.super_cache_options ||= {}
      #around_filter :lock_cache if options[:lock]
      before_filter :check_weird_cache, options
      after_filter :weird_cache, options
    end

    def skip_super_caches_page(*pages)
      options = pages.extract_options!
      options[:only] = (Array(options[:only]) + pages).flatten
      skip_before_filter :check_weird_cache, options
      skip_after_filter :weird_cache, options
    end

  end

  def check_weird_cache
    return unless perform_caching
    @cache_path ||= weird_cache_path

    if content = Rails.cache.read(@cache_path, :raw => true)
      return if content.size < 10
      logger.info "Hit #{@cache_path}"

      headers['Content-Length'] ||= content.size.to_s
      headers['Content-Type'] ||= request.format.to_s.strip unless  request.format == :all
      render :text => content, :content_type => 'text/html'
      return false
    end
  rescue ArgumentError => e
    @no_cache = true
    logger.info e.to_s
    logger.debug {e.backtrace}
  end

  def weird_cache
    return if @no_cache
    return unless perform_caching
    @cache_path ||= weird_cache_path
    @expires_in ||= 600
    return if response.body.size < 10
    self.class.benchmark "Super Cached page: #{@cache_path}" do
      Rails.cache.write(@cache_path, response.body, :raw => true, :expires_in => @expires_in.to_i)
    end
  end

  protected :check_weird_cache
  protected :weird_cache
  private
    def weird_cache_path
      path = File.join request.host, request.path
      q = request.query_string
      format = request.format.to_sym
      path = "#{path}.#{format}" if format != :html and format != :all and params[:format].blank?
      path = "#{path}?#{q}"  if !q.empty? && q =~ /=/
      path
    end
end
