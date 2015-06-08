if ROLES.include?('app')
process 'unicorn' do
  pid_file "#{CURRENT_PATH}/tmp/pids/unicorn.pid"
  start_command "bundle exec unicorn -c #{CURRENT_PATH}/config/unicorn/#{RAILS_ENV}.rb -E #{RAILS_ENV} -D"
  # stop_command "kill -QUIT `cat #{ROOT}/tmp/pids/unicorn.pid`"
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
