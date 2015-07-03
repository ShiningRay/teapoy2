
Eye.config do
  logger "#{ROOT}/log/eye.log"
end

Eye.application 'teapoy_production' do
  env 'RAILS_ENV' => RAILS_ENV, 'BUNDLE_GEMFILE' => "#{CURRENT_PATH}/Gemfile"
  working_dir CURRENT_PATH
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  # check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes
  check :memory, below: 500.megabytes, times: 3

  Dir["#{ROOT}/config/eyes/processes/*.rb"].each do |f|
    puts "loading #{f}"
    eval(IO.read(f))
  end
end
