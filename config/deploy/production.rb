# production.rb
set :deploy_to, '/home/deploy'
set :rails_env, :production
set :sidekiq_role, :sidekiq
server 'shiningray.cn', user: 'deploy', roles: [:app, :web, :db]
server 'jp.hging.net', user: 'deploy', roles: [:mail, :scheduler, :sidekiq], port: 1991
