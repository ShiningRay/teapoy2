#!/usr/bin/env puma

directory '/srv/teapoy2/current'
rackup "/srv/teapoy2/current/config.ru"
environment 'production'

pidfile "/srv/teapoy2/shared/tmp/pids/puma.pid"
state_path "/srv/teapoy2/shared/tmp/pids/puma.state"
stdout_redirect '/srv/teapoy2/shared/log/puma_access.log', '/srv/teapoy2/shared/log/puma_error.log', true


threads 1,64

bind 'unix:///srv/teapoy2/shared/tmp/sockets/puma.sock'
workers 4

# worker_timeout 3600

preload_app!

prune_bundler
