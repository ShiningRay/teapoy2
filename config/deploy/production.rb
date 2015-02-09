# production.rb


server 'jinhai.bling0.com', user: 'shiningray', roles: [:app, :web, :db]
set :rails_env, :production