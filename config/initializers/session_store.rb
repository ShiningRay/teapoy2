# coding: utf-8
# Be sure to restart your server when you modify this file.

# Teapoy::Application.config.session_store :cookie_store, :key => '_teapoy_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
#if Rails.env.production?
#  require 'action_dispatch/middleware/session/dalli_store'
#  Rails.application.config.session_store :dalli_store, :memcache_server => ['hunan.bling0.com'], :namespace => 'sessions', :key => '_session'
#else
#Teapoy::Application.config.session_store :active_record_store
Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 40.minutes, :domain => :all if Rails.env.production?
#end
