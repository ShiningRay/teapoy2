if ROLES.include?('app')
process 'mailman' do
  start_command 'ruby script/mailman.rb'
  pid_file 'tmp/pids/mailman.pid'

  daemonize true
end
end
