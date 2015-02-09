# coding: utf-8
require 'redis'
require 'redis/objects'
config = {:host => 'localhost'}
config[:driver] = :hiredis if Rails.env.production?
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # We're in smart spawning mode.
    if forked
      # Re-establish redis connection
      #redis_config = YAML.load_file("#{Rails.root.to_s}/config/redis.yml")[Rails.env]

      # The important two lines
      Redis.current.client.disconnect if Redis.current
      Redis.current = Redis.new config
    end
  end
else
  Redis.current = Redis.new(config)
end
