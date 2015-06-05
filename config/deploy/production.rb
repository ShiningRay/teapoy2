# production.rb
set :deploy_to, '/home/deploy'
set :rails_env, :production
server 'shiningray.cn', user: 'deploy', roles: [:app, :web, :db]
server '106.185.34.47', user: 'deploy', roles: [:mail, :scheduler], port: 88
