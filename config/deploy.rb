server '133.130.113.77', port: 22, roles: [:app, :web, :db], primary: true
set :repo_url,        'git@github.com:kawayuta/P1_Tech_app.git'
set :application,     'P1_Tech_app'
set :user,            'deploy'
set :ssh_options,     {
    forward_agent: true,
    user: fetch(:user),
    keys: %w(~/.ssh/p1-deploy)
}
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/var/www/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :rbenv_type, :system
set :rbenv_ruby, '2.4.1'
set :linked_dirs, fetch(:linked_dirs, []).push(
    'log',
    'tmp/pids',
    'tmp/cache',
    'tmp/sockets',
    'vendor/bundle',
    'public/system',
    'public/uploads'
)
set :linked_files, fetch(:linked_files, []).push(
    'config/database.yml',
    'config/secrets.yml'
)

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  desc 'db_seed'
  task :db_seed do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  desc 'db_reset'
  task :db_reset do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1', :bundle, :exec, :rake, 'db:migrate:reset'
        end
      end
    end
  end


  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end
