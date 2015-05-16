#!/usr/bin/env puma
ROOT = File.expand_path("../../../", __FILE__)
directory ROOT
rackup "#{ROOT}/config.ru"
environment 'development'

pidfile "#{ROOT}/tmp/pids/puma.pid"
state_path "#{ROOT}/tmp/pids/puma.state"
stdout_redirect "#{ROOT}/log/puma_access.log", "#{ROOT}/log/puma_error.log", true


threads 1,64

bind 'tcp://localhost:9000'
workers 1

worker_timeout 3600

prune_bundler
