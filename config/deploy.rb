lock '3.6.1'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :pty, true
set :repo_url, 'git@github.com:KyivKrishnaAcademy/ved_akadem_students.git'
set :deploy_to, '/var/docker/apps/ved_akadem_students'
set :linked_files, %w(.ruby-env)

set :dbname, 'postgresql://postgres:postgres@postgres:5432/va_db'
set :project, 'akademstudents'
set :packages, %w(git build-base postgresql postgresql-client nodejs-lts python)
set :app_image, 'mpugach/akadem_students_prod:latest'
set :compose_yml, 'docker-compose.prod.yml'
set :backups_path, "#{fetch(:deploy_to)}/backups"
set :builder_name, 'assets_builder'
set :keep_backups, 10
set :docker_images, %w(mpugach/akadem_students_prod:latest mpugach/akadem_students_nginx:latest)

namespace :docker do
  desc 'Deploy containers'
  task :deploy do
    invoke :'docker:pull'
    invoke :'docker:compose_up', '--no-recreate'

    Rake::Task[:'docker:stop_container'].reenable
    invoke :'docker:stop_container', fetch(:builder_name)

    Rake::Task[:'docker:recreate_builder'].reenable
    invoke :'docker:recreate_builder'

    Rake::Task[:'docker:start_builder'].reenable
    invoke :'docker:start_builder'

    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', "apk add #{fetch(:packages).join(' ')}"
    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'bundle install -j5 --retry 10 --without development test'
    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'bundle clean --force'
    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'npm install npm@3.6.0 -g && npm install'
    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'bundle exec rake assets:precompile RAILS_ENV=assets_builder'

    Rake::Task[:'docker:stop_container'].reenable
    invoke :'docker:stop_container', 'nginx'

    Rake::Task[:'docker:stop_container'].reenable
    invoke :'docker:stop_container', 'sidekiq'

    # Initial setup
    # Rake::Task[:'docker:builder_exec'].reenable
    # invoke :'docker:builder_exec', 'bundle exec rake db:structure:load'

    Rake::Task[:'docker:builder_exec'].reenable
    invoke :'docker:builder_exec', 'bundle exec rake db:migrate'

    Rake::Task[:'docker:compose_up'].reenable
    invoke :'docker:compose_up'

    Rake::Task[:'docker:stop_container'].reenable
    invoke :'docker:stop_container', fetch(:builder_name)
  end

  desc 'Start builder'
  task :start_builder do
    on roles(:all) do
      within release_path do
        sudo "docker start #{fetch(:builder_name)}"
      end
    end
  end

  desc 'Pull'
  task :pull do
    on roles(:all) do
      within release_path do
        fetch(:docker_images).each do |image|
          sudo "docker pull #{image}"
        end
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
        sudo "docker exec \"#{fetch(:builder_name)}\" sh -lc '#{args[:cmd]}'"
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
            -v #{fetch(:backups_path)}:/backups \
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

  desc 'Backup DB and files'
  task :backup do
    on roles(:all) do
      last_release = capture(:ls, '-xt', releases_path).split.first

      return unless last_release

      release_backup_path = Pathname.new('/backups').join(last_release)

      invoke :'docker:start_builder'
      invoke :'docker:builder_exec', "mkdir -p #{release_backup_path}"

      Rake::Task[:'docker:builder_exec'].reenable

      invoke(
        :'docker:builder_exec',
        "pg_dump --dbname=#{fetch(:dbname)} -F d -j 20 -Z 1 -f #{release_backup_path.join('db')}"
      )

      Rake::Task[:'docker:builder_exec'].reenable

      invoke(
        :'docker:builder_exec',
        "tar -czf #{release_backup_path.join('uploads.tar.gz')} -C /app uploads"
      )

      invoke :'docker:stop_container', fetch(:builder_name)
    end
  end

  desc 'Cleanup old backups'
  task :cleanup_backups do
    on roles(:all) do
      revisions = capture(:ls, '-x', fetch(:backups_path)).split

      if revisions.count >= fetch(:keep_backups)
        info "Keeping #{fetch(:keep_backups)} of #{revisions.count} backups"

        directories = (revisions - revisions.last(fetch(:keep_backups)))

        if directories.any?
          directories_str = directories.map { |revision| "/backups/#{revision}" }.join(' ')

          Rake::Task[:'docker:start_builder'].reenable
          invoke :'docker:start_builder'

          Rake::Task[:'docker:builder_exec'].reenable
          invoke :'docker:builder_exec', "rm -rf #{directories_str}"

          Rake::Task[:'docker:stop_container'].reenable
          invoke :'docker:stop_container', fetch(:builder_name)
        else
          info "No old revisions (keeping newest #{fetch(:keep_backups)})"
        end
      end
    end
  end

  desc 'Restore DB and files'
  task :restore do
    on roles(:all) do
      revisions = capture(:ls, '-x', fetch(:backups_path))

      if revisions.strip.empty?
        info 'Nothing to restore'

        return
      end

      info revisions

      ask :restore_release, revisions.split.last

      release_backup_path = Pathname.new('/backups').join(fetch(:restore_release))

      invoke :'docker:start_builder'
      invoke :'docker:stop_container', 'nginx'
      invoke :'docker:stop_container', 'sidekiq'

      invoke(
        :'docker:builder_exec',
        "pg_restore --dbname=#{fetch(:dbname)} -O -j 20 -c #{release_backup_path.join('db')}"
      )

      Rake::Task[:'docker:builder_exec'].reenable
      invoke(:'docker:builder_exec', 'rm -rf /app/uploads/*')
      Rake::Task[:'docker:builder_exec'].reenable
      invoke(:'docker:builder_exec', "tar -xzf #{release_backup_path.join('uploads.tar.gz')} -C /app")

      invoke :'docker:compose_up'

      Rake::Task[:'docker:stop_container'].reenable
      invoke :'docker:stop_container', fetch(:builder_name)
    end
  end
end

before :'deploy:started', :'docker:backup'
after :'deploy:published', :'docker:deploy'
after :'deploy:cleanup', :'docker:cleanup_backups'
