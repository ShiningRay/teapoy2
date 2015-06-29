# This file is used by Rack-based servers to start the application.
begin
	require 'unicorn/worker_killer'

	# Max requests per worker
	use Unicorn::WorkerKiller::MaxRequests, 5000, 10000

	# Max memory size (RSS) per worker
	use Unicorn::WorkerKiller::Oom, (300*(1024**2)), (500*(1024**2))
rescue LoadError
	puts 'Skip Unicorn WorkerKiller'
end
# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Teapoy::Application
