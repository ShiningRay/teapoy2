# coding: utf-8
lock '3.4.0'
set :application, "teapoy2"
set :scm, :git
set :repo_url, "git@github.com:hging/teapoy2.git"
set :deploy_to, '/srv/teapoy2'
set :format, :pretty
set :pty, true
set :use_sudo, false

set :branch, 'master'

## unicorn {{{
set :unicorn_rack_env, "production"
# set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
# }}}

# RVM {{{
set :rvm_type, :system
set :rvm_ruby_version, 'ruby-2.1.5'
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

set :linked_files, %w{config/database.yml config/mongoid.yml config/secrets.yml}

set :linked_dirs, %w{.eye bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets public/uploads}

namespace :eye do
  task :load do
    on roles(:all) do
      within release_path do
        execute 'bundle', 'exec', 'leye', 'load'
      end
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'eye:load'

    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      within release_path do
        execute :bundle, 'exec', 'leye', 'restart', 'unicorn'
      end
    end

    on roles(:scheduler) do
      within release_path do
        execute :bundle, 'exec', 'leye', 'restart', 'scheduler'
      end
    end

    on roles(:mail) do
      within release_path do
        execute :bundle, 'exec', 'leye', 'restart', 'mailman'
      end
    end
  end

  after :publishing, :restart

  before :restart, :write_roles do
    on roles(:all) do |host|
      within release_path do
        execute :echo, "\"#{host.roles.to_a.join(',')}\" > ROLES"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
