process 'scheduler' do
  start_command 'ruby script/scheduler.rb'
  pid_file 'tmp/pids/scheduler.pid'

  daemonize true
end
