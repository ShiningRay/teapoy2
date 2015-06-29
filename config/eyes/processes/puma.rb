if ROLES.include?('app')
process 'puma' do
  pid_file "#{CURRENT_PATH}/tmp/pids/puma.pid"
  start_command "bundle exec puma -C #{CURRENT_PATH}/config/puma/#{RAILS_ENV}.rb -e #{RAILS_ENV} -d"
  # stop_command "bundle exec pumactl stop"
  stop_signals [:QUIT, 2.seconds, :TERM, 1.seconds, :KILL]
  restart_command "kill -USR2 {PID}"
  start_timeout 100.seconds
  restart_grace 30.seconds
  # monitor_children do
  #   # restart_command 'kill -2 {PID}' # for this child process
  #   stop_command 'kill -9 {PID}'
  #   check :memory, below: 500.megabytes, times: 3
  # end
end
end
