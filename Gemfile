# encoding: UTF-8
#source 'http://rubygems.org'
Encoding.default_external= Encoding::UTF_8
if ENV['USE_TAOBAO_GEM_SOURCE']
  source 'https://ruby.taobao.org'
else
  source 'https://rubygems.org'
end
gem 'dotenv-rails'

gem 'rails', '~> 4.1.0'
# FrontEnd {{{
  gem 'turbolinks'
  gem 'jquery-turbolinks'
  gem 'remotipart', '~> 1.2'
source 'https://rails-assets.org' do
  gem 'rails-assets-icanhaz'
  gem 'rails-assets-photoswipe'
  gem 'rails-assets-waypoints'
  gem 'rails-assets-to-markdown'
end
  gem 'bootstrap-sass'
  gem "font-awesome-rails"
  gem 'autoprefixer-rails'
  gem 'jquery-rails'
  gem "jquery_mobile_rails"
  gem 'jquery-atwho-rails', :github => 'ShiningRay/jquery-atwho-rails'
  gem 'lazy_high_charts'
  gem 'bourbon'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'select2-rails'
  gem 'simditor'
  gem "non-stupid-digest-assets"
# }}}
# compatible with rails 3
gem 'rails-observers'
# gem 'protected_attributes'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'rack-cors', :require => 'rack/cors'

# database & models {{{
gem 'mysql2', platforms: [:ruby, :mingw]#, github: 'brianmario/mysql2'
gem 'composite_primary_keys'
gem 'mongoid', '~> 4.0.0'
gem 'mongoid_auto_increment'
gem 'mongoid-tree', require: 'mongoid/tree', github: 'ShiningRay/mongoid-tree'
gem 'mongoid_colored_logger', group: :development
gem 'mongoid_magic_counter_cache'
gem 'mongoid_taggable'
gem 'mongoid-observers'
# gem 'paperclip'
# gem "mongoid-paperclip", :require => "mongoid_paperclip"
gem 'carrierwave'
gem 'carrierwave-mongoid'
gem 'carrierwave-qiniu', github: 'ShiningRay/carrierwave-qiniu', branch: 'preserve-slash-in-path'

#gem "friendly_id", "~> 3.2.1"
gem 'tenacity', github: 'jwg2s/tenacity', branch: 'develop'
gem 'stringex'
gem "newrelic_rpm"
gem "newrelic_moped"
gem "newrelic-redis"
#gem "thinking-sphinx", '~> 1.3.11', require: 'thinking_sphinx'
# gem "acts_as_audited"
gem "default_value_for", "~> 3.0.0"
gem "acts_as_list"
#gem "acts_as_audited"
#gem 'httparty'
gem 'ancestry'
gem 'acts-as-taggable-on'
# }}}
# controller


# views {{{
gem 'redcarpet'
gem "kaminari"
gem 'haml'
gem 'haml-rails'
gem 'themes_for_rails', github: "ShiningRay/themes_for_rails"
gem 'responders'
gem 'bootstrap-kaminari-views'
# }}}

gem 'json'
gem 'oj'
gem 'rails-i18n', '~> 4.0.0'

# Gems used only for assets and not required
# in production environments by default.
  #gem 'therubyracer', platforms: :ruby

# gem "oauth"
# gem "oauth-plugin"
# gem "oauth_china", github: 'iamzhangdabei/oauth_china'
gem 'weibo_2'
gem 'simple_form'#, git: "https://github.com/plataformatec/simple_form"
gem 'authlogic'
gem 'aasm'
gem 'sidekiq'
# gem 'faye'
# gem 'private_pub'
gem 'rack-raw-upload'
gem 'has_scope'

gem "active_model_serializers", '~> 0.9.2'
gem 'draper'
gem 'redis-objects', require: 'redis/objects'
gem 'dalli'
gem 'connection_pool'
gem 'browser'

group :production do
  #gem 'exception_notification'
  gem 'hiredis', platforms: [:ruby, :jruby]
end
# gem 'unicorn', platforms: :ruby
# gem 'unicorn-worker-killer', platforms: :ruby
gem 'puma'
# gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"

gem 'mailman', require: false
gem 'preferences', github: 'ShiningRay/preferences'
#gem "galetahub-simple_captcha", require: "simple_captcha", git: 'git://github.com/galetahub/simple-captcha.git'
gem 'whenever', require: false
gem 'nokogiri'
gem 'daemons', '~> 1.1.8', require: false

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'fuubar'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'byebug', '~> 4.0.0'
  gem 'pry-stack_explorer'
  gem 'quiet_assets'
  # gem "railroady"
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-rails'
  gem 'rb-inotify', platforms: :ruby, require: false
  gem 'rb-fsevent', platforms: :ruby, require: false
  #gem 'rb-fchange', platforms: [:mswin, :mingw], require: false
  # gem 'ruby_gntp'
end

# gem 'thin', platforms: [:ruby, :mingw], require: false

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano3-unicorn', require: false
  # gem 'capistrano3-puma', require: false, github: "seuros/capistrano-puma"
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-foreman', require: false, github: 'ShiningRay/capistrano-foreman'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'guard-livereload'
  gem 'guard-rubocop'
  gem 'rack-livereload'
  gem 'rack-mini-profiler', require: false
  gem 'xray-rails'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'mongoid-rspec'
  gem 'forgery'
  gem 'webmock', require: false
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'timecop'
end

gem 'sinatra', '>= 1.3.0', require: nil
gem 'rufus-scheduler', require: false

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


# gem 'escape_utils'
gem "simple_captcha2", require: 'simple_captcha'
# gem "galetahub-simple_captcha", :require => "simple_captcha"

gem 'rack-weixin'#, github: 'ShiningRay/rack-weixin'
gem 'pundit'
gem 'eye', github: 'kostya/eye', require: false
gem 'foreman', require: false
gem 'mini_magick'
gem 'annotate', '~> 2.6.6'
gem 'spring-commands-rspec', group: :development
gem 'simplecov', :require => false, :group => :test
