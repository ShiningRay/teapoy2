#!/usr/bin/env puma

DEPLOY_ROOT = ENV['DEPLOY_ROOT'] || '/home/deploy'

directory "#{DEPLOY_ROOT}/current"
rackup "#{DEPLOY_ROOT}/current/config.ru"
environment 'production'

pidfile "#{DEPLOY_ROOT}/shared/tmp/pids/puma.pid"
state_path "#{DEPLOY_ROOT}/shared/tmp/pids/puma.state"
stdout_redirect "#{DEPLOY_ROOT}/shared/log/puma_access.log", "#{DEPLOY_ROOT}/shared/log/puma_error.log", true


threads 1,64

bind "unix://#{DEPLOY_ROOT}/shared/tmp/sockets/puma.sock"
workers ENV['PUMA_WORKERS'] || 1
# worker_timeout 3600

preload_app!

prune_bundler
