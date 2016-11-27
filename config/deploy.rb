lock '3.6.1'

Airbrussh.configure do |config|
  config.command_output = true
end

set :pty, true
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :repo_url, 'git@github.com:KyivKrishnaAcademy/ved_akadem_students.git'
set :deploy_to, '/var/docker/apps/ved_akadem_students'
set :linked_files, %w(.ruby-env)

set :project, 'akademstudents'
set :packages, %w(git build-base postgresql-client nodejs-lts python)
set :app_image, 'mpugach/akadem_students_prod:latest'
set :compose_yml, 'docker-compose.prod.yml'
set :builder_name, 'assets_builder'

namespace :docker do
  desc 'Deploy containers'
  task :deploy do
    invoke :'docker:compose_up', '--no-recreate'
    invoke :'docker:stop_container', fetch(:builder_name)
    invoke :'docker:recreate_builder'
    invoke :'docker:start_builder'

    invoke :'docker:builder_exec', "apk add #{fetch(:packages).join(' ')}"
    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'bundle install -j5 --retry 10 --without development test'
    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'npm install npm@3.6.0 -g && npm install'
    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'bundle exec rake assets:precompile RAILS_ENV=assets_builder'

    # Initial setup
    # Rake::Task[:'docker:builder_exec'].reenable
    # invoke :'docker:builder_exec', 'bundle exec rake db:structure:load'

    Rake::Task[:'docker:stop_container'].reenable
    invoke :'docker:stop_container', 'nginx'

    Rake::Task[:'docker:compose_up'].reenable
    invoke :'docker:compose_up'

    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'bundle exec rake db:migrate'

    Rake::Task[:'docker:stop_container'].reenable
    invoke :'docker:stop_container', fetch(:builder_name)
  end

  after :'deploy:published', :'docker:deploy'

  desc 'Start builder'
  task :start_builder do
    on roles(:all) do
      within release_path do
        sudo "docker start #{fetch(:builder_name)}"
      end
    end
  end

  desc 'Stop container'
  task :stop_container, %i(container) do |_t, args|
    on roles(:all) do
      within release_path do
        execute <<-SHELL
          if sudo docker ps | grep #{args[:container]}
            then sudo docker stop #{args[:container]}
          fi
        SHELL
      end
    end
  end

  desc 'Execute on builder'
  task :builder_exec, %i(cmd) do |_t, args|
    on roles(:all) do
      within release_path do
        sudo "docker exec -it \"#{fetch(:builder_name)}\" sh -lc '#{args[:cmd]}'"
      end
    end
  end

  desc 'docker-compose up'
  task :compose_up, %i(options) do |_t, args|
    args.with_defaults(options: '')

    on roles(:all) do
      within release_path do
        sudo "docker-compose -p #{fetch(:project)} -f #{fetch(:compose_yml)} up -d #{args[:options]}"
      end
    end
  end

  desc 'Recreate builder'
  task :recreate_builder do
    on roles(:all) do
      within release_path do
        execute <<-SHELL
          if sudo docker ps -a | grep #{fetch(:builder_name)}
            then sudo docker rm #{fetch(:builder_name)}
          fi
        SHELL

        sudo <<-SHELL
          docker create \
            -v builder-cache-node_modules:/app/node_modules \
            -v builder-cache-client-node_modules:/app/client/node_modules \
            -v #{fetch(:project)}_public-prod:/app/public \
            -v #{fetch(:project)}_bundle-prod:/usr/local/bundle \
            -v #{fetch(:project)}_uploads-prod:/app/uploads \
            -e RAILS_ENV=production \
            --name #{fetch(:builder_name)} \
            --network #{fetch(:project)}_default \
            #{fetch(:app_image)} \
            top -b
        SHELL
      end
    end
  end

  desc 'docker-compose logs -f'
  task :logs do
    on roles(:all) do
      within current_path do
        sudo "docker-compose -p #{fetch(:project)} -f #{fetch(:compose_yml)} logs -f"
      end
    end
  end
end
