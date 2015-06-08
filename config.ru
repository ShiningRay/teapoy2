# This file is used by Rack-based servers to start the application.
require 'unicorn/worker_killer'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 30720, 40960

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (300*(1024**2)), (500*(1024**2))
# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Teapoy::Application
