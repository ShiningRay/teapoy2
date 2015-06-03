
ROOT = ENV['APP_ROOT'] || '/home/deploy/current'
Bundle = "bundle exec"
RAILS_ENV = ENV['RAILS_ENV'] || 'production'

Eye.config do
  logger "#{ROOT}/log/eye.log"
end

Eye.application 'teapoy' do
  env 'RAILS_ENV' => RAILS_ENV
  working_dir ROOT
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  # check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

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

  process 'mailman' do
    pid_file 'tmp/pids/mailman_monitor.pid'
    start_command 'ruby script/mailman.rb start'
    stop_command 'ruby script/mailman.rb stop'
  end

  process 'sidekiq' do
    pid_file 'tmp/pids/sidekiq.pid'
    start_command "bundle exec sidekiq --index 0 --pidfile '#{ROOT}/tmp/pids/sidekiq.pid' --environment #{RAILS_ENV} --logfile #{ROOT}/log/sidekiq.log --daemon"
    stop_signals 'bundle exec sidekiqctl stop {PID}'
  end

  process 'scheduler' do
    pid_file 'tmp/pids/scheduler_monitor.pid'
    start_command 'ruby script/scheduler.rb start'
    stop_command 'ruby script/scheduler.rb stop'
  end
end
