# coding: utf-8
Teapoy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.

  config.cache_classes = false
  # Log error messages when you accidentally call methods on nil.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  # Don't care if the mailer can't send
  config.action_mailer.default_url_options = { :host => "example.com", :only_path => false }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :test
  #config.sass.debug_info = true
  #config.sass.quiet = false
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  # Do not compress assets
  config.assets.compress = false
  config.assets.compile = true
  #config.serve_static_assets = true
  #config.assets.digest = false
  # Expands the lines which load the assets
  config.assets.debug = true
  config.assets.logger = false
  # config.action_controller.asset_host = "http://localhost:3000"
  config.cache_store = :memory_store
  #config.session_store :mem_cache_store
  #config.cache_store = :dalli_store, '127.0.0.1' #,{ :compression => true}
  #config.session_store :mem_cache_store#, 'localhost', :expires_after => 12.hours
  # Raise exception on mass assignment protection for Active Record models
  #config.active_record.mass_assignment_sanitizer = :strict
  # config.middleware.delete Rack::Cache
  Mongoid.logger.level = Logger::DEBUG
  Moped.logger.level = Logger::DEBUG
  config.log_level = :debug
  # config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload)

  # BetterErrors.editor = :sublime
  if defined? BetterErrors
    BetterErrors.editor = "atm://open?url=file://%{file}&line=%{line}"
  end
  some_paths = %w"/assets
  /system/
  /images/
  /stylesheets/
  /javascripts/
  /favicon.ico
  /icons/
  /avatars/
  /__rack/
  /au/"
  # config.quiet_assets_paths += some_paths
  # config.middleware.insert_after 'ActionDispatch::Static', 'QuietRoutingError'
  config.middleware.use 'QuietRoutingError'
  require 'rack-mini-profiler'
  if defined?(Rack::MiniProfiler)
    Rack::MiniProfiler.config.skip_paths = some_paths
    Rack::MiniProfiler.config.start_hidden = !ENV['show_profiler']
  end
end
