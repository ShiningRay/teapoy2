
Eye.config do
  logger "#{CURRENT_PATH}/log/eye.log"
end

Eye.application 'teapoy_dev' do
  env 'RAILS_ENV' => RAILS_ENV
  working_dir CURRENT_PATH
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  # check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

  Dir['config/eyes/processes/*.rb'].each do |f|
    puts "loading #{f}"
    eval(IO.read(f))
  end
end
