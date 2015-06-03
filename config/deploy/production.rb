# production.rb
set :deploy_to, '/home/deploy'
set :rails_env, :production
server 'shiningray.cn', user: 'deploy', roles: [:app, :web, :db]
