# coding: utf-8
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Teapoy::Application.initialize!
#Rails.application.initialize!(:assets)
#unless RUBY_VERSION >= '1.9' or Rails.env.production? or Rails.env == 'local_production'
#  Sprockets::Bootstrap.new(Rails.application).run
#end
#Haml::Template.options[:suppress_eval] = true

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # Reset Rails's object cache
    # Only works with DalliStore
    Rails.cache.reset if forked

    # Reset Rails's session store
    # If you know a cleaner way to find the session store instance, please let me know
    #ObjectSpace.each_object(ActionDispatch::Session::DalliStore) { |obj| obj.reset }
  end
end
