# coding: utf-8
lock '3.3.5'
set :application, "teapoy2"
set :scm, :git
set :repo_url, "git@github.com:hging/teapoy2.git"
set :deploy_to, '/srv/teapoy2'
set :format, :pretty
set :pty, true
set :use_sudo, false

set :branch, 'master'

## PUMA {{{
# set :unicorn_rack_env, "production"
# set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
set :puma_threads, [1, 64]
set :puma_workers, 4
set :puma_worker_timeout, 60 * 60
set :puma_prune_bundler, true
# }}}

# RVM {{{
set :rvm_install_with_sudo, true
set :rvm_ruby_string, 'ruby-2.1.5'
set :rvm_type, :system
set :rvm_install_type, :stable
set :rvm_install_ruby_threads, 8
set :rvm_install_ruby, :install
# before 'deploy:setup', 'rvm:install_rvm'
# before 'deploy:setup', 'rvm:install_ruby'
# }}}


# NEWRELIC {{{
set :newrelic_appname, "Teapoy"
set :newrelic_revision, `hg log -r . --template '{rev}\n'`
set :newrelic_changelog, `hg log -r . --template '{desc}\n'`
after "deploy:updated", "newrelic:notice_deployment"
# }}}

# Foreman {{{
set :foreman_use_sudo, 'rvm'
set :foreman_template, 'upstart'
set :foreman_export_path, '/etc/init'
set :foreman_options, {
  app: fetch(:application),
  log: File.join(shared_path, 'log')
}
# }}}

set :linked_files, %w{config/database.yml config/mongoid.yml}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets public/uploads}

namespace :eye do
  task :load do
    on roles(:app) do
      within current_path do
        execute 'bundle', 'exec', 'eye', 'l', 'app.eye'
      end
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'puma:restart'
      invoke 'mailman:restart'
      invoke 'scheduler:restart'
      invoke 'eye:load'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
