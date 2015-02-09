# coding: utf-8
module CachesHelper
  def cache_for_current_user(name = {}, options = {}, &block)
    options.reverse_merge!(:expires_in => 8.hour)
    cache cache_key_for_current_user(name), options, &block
  end

  def cache_without_anonymous(name = {}, options = {}, &block)
    options.reverse_merge!(:expires_in => 8.hour)
    if logged_in?
      cache name, options, &block
    else
      yield
    end
  end

  def cache_for_current_user_without_anonymous(name = {}, options = {}, &block)
    options.reverse_merge!(:expires_in => 8.hour)
    if logged_in?
      cache cache_key_for_current_user(name), options, &block
    else
      yield
    end
  end
end