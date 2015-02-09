
namespace :mailman do
  control_mailman = -> (action) do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :ruby, "script/mailman.rb", action
        end
      end
    end
  end
  task :start do
    control_mailman['start']
  end
  task :stop do
    control_mailman['stop']
  end
  task :restart do
    control_mailman['restart']
  end
end

# after "deploy:stop", "mailman:stop"
# after "deploy:start", "mailman:start"
# before "deploy:publishing", "mailman:stop"
# after "deploy:publishing", "mailman:start"
