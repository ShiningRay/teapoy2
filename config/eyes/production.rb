
Eye.config do
  logger "#{ROOT}/log/eye.log"
end

Eye.application 'teapoy_production' do
  env 'RAILS_ENV' => RAILS_ENV
  working_dir ROOT
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  # check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

  Dir['config/eyes/processes/*.rb'].each do |f|
    puts "loading #{f}"
    eval(IO.read(f))
  end
end
