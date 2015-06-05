# coding: utf-8
Teapoy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true
  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true
  # Compress JavaScripts and CSS
  config.assets.compress = true
  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true
  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.initialize_on_precompile = false

  # Generate digests for assets URLs
  config.assets.digest = true
  config.assets.expire_after 1.weeks
  # Compress both stylesheets and JavaScripts
  config.assets.js_compressor  = :uglifier
  #config.assets.css_compressor = :scss
  #config.sass.quiet = true
  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  config.log_level = :error

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  #config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = Proc.new { |source, request|
    if request && request.ssl?
      "#{request.protocol}#{request.host_with_port}"
    else
      "http://assets.bling0.com"
    end
  }

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => "www.bling0.com" }
  #
  # example:
  #
  #  config.action_mailer.smtp_settings = {
  #    :address => 'smtp.exmail.qq.com',
  #    :port => 25,
  #    :domain => 'bling0.com',
  #    :user_name => 'admin@bling0.com',
  #    :password => '1234qwer',
  #    :enable_starttls_auto => true,
  #    :authentication => :plain
  #  }
  #
  config.action_mailer.smtp_settings = Rails.application.secrets.smtp_settings.symbolize_keys


  config.cache_store = :dalli_store, *Rails.application.secrets.mem_cache
  #config.session_store :cache_store, :expire_after => 1.day
  #require 'rack/cache'
end
