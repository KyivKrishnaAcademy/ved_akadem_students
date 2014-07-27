# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'ved_akadem_students'
set :repo_url, 'git@github.com:mpugach/ved_akadem_students.git'
application = 'ved_akadem_students'
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.1'
set :deploy_to, '/var/www/apps/ved_akadem_students'
set :ssh_options, { forward_agent: true }
set :pty, true


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
      sudo    "mkdir -p /usr/local/nginx/conf/sites-enabled"

      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      upload!('shared/puma.conf', "#{shared_path}/puma.conf")

      #sudo 'service nginx stop'
      sudo "rm -f /usr/local/nginx/conf/nginx.conf"
      sudo "rm -f /usr/local/nginx/conf/sites-enabled/puma.conf"
      sudo "ln -sf #{shared_path}/nginx.conf /usr/local/nginx/conf/nginx.conf"
      sudo "ln -sf #{shared_path}/puma.conf /usr/local/nginx/conf/sites-enabled/puma.conf"
      #sudo 'echo "/var/www/apps/ved_akadem_students/current,deployer,/var/www/apps/ved_akadem_students/current/config/puma.rb,/var/www/apps/ved_akadem_students/current/log/puma.log" > /etc/puma.conf'
      sudo 'service nginx restart'

      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
          execute :rake, "db:reset"
        end
      end
    end
  end

  desc 'Create symlink'
  task :symlink do
    on roles(:all) do
      execute "ln -sf #{release_path} #{current_path}"
      execute "mkdir -p #{release_path}/tmp/puma"
      execute "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -sf #{shared_path}/system #{release_path}/public/system"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "service nginx restart"
    end
  end

  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'
  
  after :updating, 'deploy:symlink'

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'
end

namespace :puma do
  desc "Start Puma"
  task :start do
    run "sudo /etc/init.d/puma start #{application}"
  end

  desc "Stop Puma"
  task :stop do
    run "sudo /etc/init.d/puma stop #{application}"
  end

  desc "Restart Puma"
  task :restart do
    run "sudo /etc/init.d/puma restart #{application}"
  end

  desc "create a shared tmp dir for puma state files"
  task :after_symlink do
    run "sudo rm -rf #{release_path}/tmp"
    run "ln -s #{shared_path}/tmp #{release_path}/tmp"
  end
end
