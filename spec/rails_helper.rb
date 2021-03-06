# coding: utf-8
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'rubygems'
require File.expand_path("../../config/environment", __FILE__)
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'factory_girl'
require "authlogic/test_case"
require 'webmock/rspec'
require "pundit/rspec"
require 'capybara/user_agent'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit

Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
end

Capybara::Webkit.configure do |config|
  config.allow_url("ajax.aspnetcdn.com")
  config.allow_url("libs.baidu.com")
  config.allow_url("log.hm.baidu.com")
  config.allow_url("hm.baidu.com")
end

class ActionController::Caching::Sweeper
  def expire_fragment(*args)

  end
end


RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Capybara::UserAgent::DSL

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.include FactoryGirl::Syntax::Methods

  config.before do
    Rails.application.routes.default_url_options[:host] = 'www.bling0.com'
  end

  config.before(:example) do |example|
    if example.metadata[:type] == :feature
      ActiveRecord::Base.observers.enable :all
      Mongoid.observers.enable :all
    else
      ActiveRecord::Base.observers.disable :all
      Mongoid.observers.disable :all
      # observers = Array(example.metadata[:observer] || example.metadata[:observers]).flatten
      observers = []
      # turn on observers as needed
      ActiveRecord::Base.observers.enable( *observers ) if observers.size > 0
      ActiveRecord::Base.observers.enable described_class if described_class.is_a?(ActiveRecord::Observer)
      Mongoid.observers.enable described_class if described_class.is_a?(Mongoid::Observer)
    end
  end


  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner[:active_record].strategy = :deletion
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner[:active_record].clean_with(:truncation)
    # FactoryGirl.lint
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Rails.cache.clear
  end

  config.infer_spec_type_from_file_location!
  config.filter_run_excluding :broken => true

  config.include ActiveSupport::Testing::TimeHelpers
  config.include AuthenticationHelper

  config.around(:each) do |example|
    if example.metadata[:type] == :feature
      WebMock.allow_net_connect!
      # VCR.turned_off { example_method.run }
      example.run
      # we don't redisable net connect for webmock here because selenium-webdriver will do some cleanup job after example finished
    else
      WebMock.disable_net_connect!
      example.run
    end
  end
end
