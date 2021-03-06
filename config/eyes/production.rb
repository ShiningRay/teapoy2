
Eye.config do
  logger "#{CURRENT_PATH}/log/eye.log"
end

Eye.application 'teapoy_production' do
  env 'RAILS_ENV' => RAILS_ENV, 'BUNDLE_GEMFILE' => "#{CURRENT_PATH}/Gemfile", 'HOME' => '/home/deploy'
  working_dir CURRENT_PATH
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  stdall "#{CURRENT_PATH}/log/eye_error.log"
  # check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes
  check :memory, below: 500.megabytes, times: 3

  Dir["#{CURRENT_PATH}/config/eyes/processes/*.rb"].each do |f|
    puts "loading #{f}"
    eval(IO.read(f))
  end
end
