# encoding: utf-8
require 'digest/md5'
module PostLock
  extend ActiveSupport::Concern

  included do
    before_filter :check_lock_post
    after_filter :release_lock_post
  end

  #module InstanceMethods
    def check_lock_post
      return unless request.post?
      return if logged_in? and current_user.is_admin?
      @lock_name = "L#{logged_in? ? current_user.id : request.session_options[:id]}"
      if Rails.cache.exist?(@lock_name, :raw => true)
        respond_to do |format|
          format.json do
            render :json => {:error => '您提交得太快了，请稍后尝试'}
          end
          format.html {render :text => '您提交得太快了，请稍后尝试'}
        end
      end
      @lock_key = "#{Time.now.to_i}.#{rand()}"
      # release lock after 20 second
      Rails.cache.write(@lock_name, @lock_key, :expires_in => 20.seconds, :raw => true)
      logger.debug{"Lock with #{@lock_name}:#{@lock_key}"}
    end

    def release_lock_post
      if request.post? and @lock_name
        content = Rails.cache.read(@lock_name, :raw => true)
        logger.debug{"Current Lock: #{@lock_name}, #{@lock_key}, #{content}"}
        if content && content == @lock_key
          Rails.cache.delete(@lock_name)
        end
      end
    end
  end

  module ClassMethods
    def check_duplicate field, options = {}
      field = field.to_s if field.is_a?(Symbol)
      if field.is_a?(String)
        getfield = Proc.new do |p|
          result = p
          field.split(/\//).compact.each do |f|
            result = result[f]
            break if result.blank?
          end
          result
        end
      end
      before_filter(options) do |controller|
        if controller.request.post?
          begin
            controller.instance_eval do
              val = getfield.call(params)
              unless val.blank?
                thishash = Digest::MD5.hexdigest(val.to_s)

                if session[:last_post] == thishash
                  render :text => '请勿重复提交'
                else
                  session[:last_post] = thishash
                end
              end
            end
          rescue => e
            logger.info {e.message}
            logger.info {e.backtrace.join("\n")}
          end
        end
      end
    rescue => e
      logger.info {e.message}
      logger.info {e.backtrace.join("\n")}
    end
  #end
end
