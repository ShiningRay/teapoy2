# paths
app_path = "/home/deploy"
working_directory "#{app_path}/current"
pid               "#{app_path}/current/tmp/pids/unicorn.pid"

# listen
listen "#{app_path}/current/tmp/sockets/unicorn.sock", :backlog => 1024
# listen 9292, :tcp_nopush => true

# logging
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

# workers
worker_processes 3
timeout 60

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

# preload
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
  if defined?(Redis)
    Redis.current.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end
