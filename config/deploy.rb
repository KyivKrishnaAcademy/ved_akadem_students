# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'ved_akadem_students'
set :repo_url, 'git@github.com:mpugach/ved_akadem_students.git'
application = 'ved_akadem_students'
set :rvm_type, :system
set :rvm_ruby_version, '2.1.1'
set :deploy_to, '/var/www/apps/ved_akadem_students'
set :ssh_options, { forward_agent: true }
set :pty, true

namespace :foreman do
  desc 'Start server'
  task :start do
    on roles(:all) do
      sudo "start #{application}"
    end
  end

  desc 'Stop server'
  task :stop do
    on roles(:all) do
      sudo "stop #{application}"
    end
  end

  desc 'Restart server'
  task :restart do
    on roles(:all) do
      sudo "restart #{application}"
    end
  end

  desc 'Server status'
  task :status do
    on roles(:all) do
      execute "initctl list | grep #{application}"
    end
  end
end

namespace :git do
  desc 'Deploy'
  task :deploy do
    ask(:message, "Commit message?")
    run_locally do
      execute "git add -A"
      execute "git commit -m '#{fetch(:message)}'"
      execute "git push"
    end
  end
end

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Setup'
  task :setup do
    on roles(:all) do
      execute "mkdir -p #{shared_path}/config/"
      execute "mkdir -p /var/www/apps/#{application}/run/"
      execute "mkdir -p /var/www/apps/#{application}/log/"
      execute "mkdir -p /var/www/apps/#{application}/socket/"
      execute "mkdir -p #{shared_path}/system"
      execute "mkdir -p /var/www/log"

      sudo "ln -sf /var/log/upstart /var/www/log/upstart"

      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/Procfile', "#{shared_path}/Procfile")
      upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")

      sudo 'service nginx stop'
      sudo "rm -f /usr/local/nginx/conf/nginx.conf"
      sudo "ln -sf #{shared_path}/nginx.conf /usr/local/nginx/conf/nginx.conf"
      sudo 'service nginx start'

      within release_path do
        with rails_env: 'production' do
          execute "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
          execute :rake, "db:reset"
        end
      end
    end
  end

  desc 'Create symlink'
  task :symlink do
    on roles(:all) do
      execute "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -sf #{shared_path}/Procfile #{release_path}/Procfile"
      execute "ln -sf #{shared_path}/system #{release_path}/public/system"
    end
  end

  desc 'Foreman init'
  task :foreman_init do
    on roles(:all) do
      foreman_temp = "/var/www/tmp/foreman"
      execute  "mkdir -p #{foreman_temp}"
      # Создаем папку current для того, чтобы foreman создавал upstart файлы с правильными путями
      execute "ln -sf #{release_path} #{current_path}"

      within current_path do
        execute "cd #{current_path}"
        execute :bundle, "exec foreman export upstart #{foreman_temp} -a #{application} -u deployer -l /var/www/apps/#{application}/log -d #{current_path}"
      end

      sudo "mv #{foreman_temp}/* /etc/init/"
      sudo "rm -r #{foreman_temp}"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "restart #{application}"
    end
  end

  # after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'

  after :updating, 'deploy:symlink'

  after :setup, 'deploy:foreman_init'

  after :foreman_init, 'foreman:start'

  before :foreman_init, 'rvm:hook'

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'
end
