# coding: utf-8
require 'redis'
require 'redis/objects'
config = {:host => 'localhost'}
config[:driver] = :hiredis if Rails.env.production?
Redis.current = Redis.new(config)
