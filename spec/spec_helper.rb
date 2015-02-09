# coding: utf-8
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'rubygems'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'factory_girl'
require "authlogic/test_case"
require 'webmock/rspec'
require "pundit/rspec"
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

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
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.include FactoryGirl::Syntax::Methods

  config.before do
    Rails.application.routes.default_url_options[:host] = 'www.bling0.com'
  end

  config.before(:example) do
    ActiveRecord::Base.observers.disable :all
    Mongoid.observers.disable :all
    # observers = Array(example.metadata[:observer] || example.metadata[:observers]).flatten
    observers = []
    # turn on observers as needed
    ActiveRecord::Base.observers.enable *observers if observers.size > 0
    ActiveRecord::Base.observers.enable described_class if described_class.is_a?(ActiveRecord::Observer)
    Mongoid.observers.enable described_class if described_class.is_a?(Mongoid::Observer)
  end


  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Rails.cache.clear
  end
  config.filter_run_excluding :broken => true

end
