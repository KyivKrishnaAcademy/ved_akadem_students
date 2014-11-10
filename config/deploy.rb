# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'ved_akadem_students'
set :repo_url, 'git@bitbucket.org:maksym_pugach/ved_akadem_students.git'
application = 'ved_akadem_students'
set :rvm_type, :user
set :rvm_ruby_version, '2.1.1'
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

  desc 'Copy shared'
  task :copy_shared do
    on roles(:all) do
      execute "mkdir -p #{shared_path}/config/Backup/models"
      execute "mkdir -p /var/www/apps/#{application}/run/"
      execute "mkdir -p /var/www/apps/#{application}/log/"
      execute "mkdir -p /var/www/apps/#{application}/socket/"
      execute "mkdir -p #{shared_path}/uploads/"
      execute "mkdir -p #{shared_path}/system"
      execute 'mkdir -p /var/www/log'
      sudo    'mkdir -p /usr/local/nginx/conf/sites-enabled'

      upload!('shared/Backup/config.rb', "#{shared_path}/config/Backup/config.rb")
      upload!('shared/Backup/models/daily.rb', "#{shared_path}/config/Backup/models/daily.rb")
      upload!('shared/Backup/models/monthly.rb', "#{shared_path}/config/Backup/models/monthly.rb")
      upload!('shared/Backup/models/weekly.rb', "#{shared_path}/config/Backup/models/weekly.rb")
      upload!('shared/Backup/models/manual.rb', "#{shared_path}/config/Backup/models/manual.rb")
      upload!('shared/database.yml', "#{shared_path}/config/database.yml")
      upload!('shared/recaptcha.rb', "#{shared_path}/config/recaptcha.rb")
      upload!('shared/mailer.yml', "#{shared_path}/config/mailer.yml")
      upload!('shared/nginx.conf', "#{shared_path}/nginx.conf")
      upload!('shared/ved_akadem_students.conf', "#{shared_path}/ved_akadem_students.conf")

      execute "chmod -R 700 #{shared_path}/config"

      sudo 'rm -f /usr/local/nginx/conf/nginx.conf'
      sudo 'rm -f /usr/local/nginx/conf/sites-enabled/ved_akadem_students.conf'
      sudo "ln -sf #{shared_path}/nginx.conf /usr/local/nginx/conf/nginx.conf"
      sudo "ln -sf #{shared_path}/ved_akadem_students.conf /usr/local/nginx/conf/sites-enabled/ved_akadem_students.conf"
    end
  end

  desc 'Setup'
  task :setup do
    on roles(:all) do
      sudo 'touch /etc/puma.conf'
      sudo 'service puma add /var/www/apps/ved_akadem_students/current deployer'
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
      execute "mkdir -p #{shared_path}/tmp/puma"
      sudo    "rm -rf #{release_path}/tmp"
      execute "ln -s #{shared_path}/tmp #{release_path}/tmp"
      execute "ln -s #{shared_path}/uploads #{release_path}/uploads"
      execute "ln -s #{shared_path}/config/Backup ~/Backup"
      execute "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -sf #{shared_path}/config/recaptcha.rb #{release_path}/config/initializers/recaptcha.rb"
      execute "ln -sf #{shared_path}/config/mailer.yml #{release_path}/config/mailer.yml"
      execute "ln -sf #{shared_path}/system #{release_path}/public/system"

      execute "ln -sf #{release_path} #{current_path}"
    end
  end

  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'

  after :updating, 'deploy:symlink'

  before :setup, 'deploy:starting'
  before :setup, 'deploy:updating'
  before :setup, 'bundler:install'
  before :setup, 'deploy:copy_shared'
end

namespace :puma do
  desc 'Restart application'
  task :restart do
    on roles(:app) do
      sudo "service puma restart #{application} && sleep 2"
      sudo 'service nginx restart'
    end
  end
  after 'deploy:restart', 'puma:restart'

  desc 'Start application'
  task :start do
    on roles(:app) do
      sudo "service puma start #{application} && sleep 2"
      sudo 'service nginx start'
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      sudo "service puma stop #{application}"
      sudo 'service nginx stop'
    end
  end
  before 'deploy:starting', 'puma:stop'

  desc 'Application status'
  task :status do
    on roles(:app) do
      sudo 'service nginx status'
      sudo "service puma status #{application}"
    end
  end
end

namespace :db do
  desc 'Backup DB'
  task :backup do
    on roles(:app) do
      execute "cd #{current_path}; backup perform -t manual"
    end
  end
  after 'deploy:starting', 'db:backup'
end
