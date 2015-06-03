if ROLES.include?('app')
process 'puma' do
  pid_file "tmp/pids/puma.pid"
  start_command "bundle exec puma -C #{ROOT}/config/puma/#{RAILS_ENV}.rb --daemon"
  stop_command "bundle exec pumactl -S #{ROOT}/tmp/pids/puma.state stop"
  monitor_children do
    # restart_command 'kill -2 {PID}' # for this child process
    stop_command 'kill -9 {PID}'
    check :memory, below: 2048.megabytes, times: 3
  end
end
end
