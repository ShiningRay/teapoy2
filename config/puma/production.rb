#!/usr/bin/env puma

ROOT = ENV['APP_ROOT'] || '/srv/teapoy2/current'

directory "#{ROOT}/current"
rackup "#{ROOT}/current/config.ru"
environment 'production'

pidfile "#{ROOT}/shared/tmp/pids/puma.pid"
state_path "#{ROOT}/shared/tmp/pids/puma.state"
stdout_redirect "#{ROOT}/shared/log/puma_access.log", "#{ROOT}/shared/log/puma_error.log", true


threads 1,64

bind "unix://#{ROOT}/shared/tmp/sockets/puma.sock"
workers ENV['PUMA_WORKERS'] || 4
# worker_timeout 3600

preload_app!

prune_bundler
