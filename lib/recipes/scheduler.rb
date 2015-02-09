
namespace :scheduler do
  control_scheduler = -> (action) do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :ruby, "script/scheduler.rb", action
        end
      end
    end
  end
  task :start do
    control_scheduler['start']
  end
  task :stop do
    control_scheduler['stop']
  end
  task :restart do
    control_scheduler['restart']
  end
end

# after "deploy:finished",     "scheduler:stop"
# after "deploy:started",    "scheduler:start"
# before "deploy:publishing", "scheduler:stop"
# after "deploy:publishing",  "scheduler:start"
