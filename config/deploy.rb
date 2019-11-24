lock '3.11.2'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :pty, true
set :repo_url, 'git@github.com:KyivKrishnaAcademy/ved_akadem_students.git'
set :deploy_to, '/var/docker/apps/ved_akadem_students'
set :linked_files, %w[.ruby-env]

set :dbname, 'postgresql://postgres:postgres@postgres:5432/va_db'
set :project, 'akademstudents'
set :compose_yml, 'docker-compose.prod.yml'
set :backups_path, "#{fetch(:deploy_to)}/backups"
set :builder_name, 'application'
set :keep_backups, 10
set :docker_images, %w[mpugach/akadem_students_prod:latest mpugach/akadem_students_nginx:latest]
set :project_home, '/home/app/students_crm'

# rubocop:disable Metrics/BlockLength
namespace :docker do
  desc 'Deploy containers'
  task :deploy do
    invoke! :'docker:pull'
    invoke! :'docker:compose_up'

    # Initial setup
    # invoke! :'docker:builder_exec', 'bundle exec rake db:structure:load'
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
  task :stop_container, %i[container] do |_t, args|
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
  task :builder_exec, %i[cmd] do |_t, args|
    on roles(:all) do
      within release_path do
        sudo "docker exec \"#{fetch(:builder_name)}\" sh -lc '#{args[:cmd]}'"
      end
    end
  end

  desc 'docker-compose up'
  task :compose_up, %i[options] do |_t, args|
    args.with_defaults(options: '')

    on roles(:all) do
      within release_path do
        sudo "docker-compose -p #{fetch(:project)} -f #{fetch(:compose_yml)} up -d #{args[:options]}"
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
      db_backup_cmd = "pg_dump --dbname=#{fetch(:dbname)} -F d -j 20 -Z 1 -f #{release_backup_path.join('db')}"
      images_backup_cmd = "tar -czf #{release_backup_path.join('uploads.tar.gz')} -C #{fetch(:project_home)} uploads"

      invoke! :'docker:stop_container', 'nginx'
      invoke! :'docker:stop_container', 'sidekiq'
      invoke! :'docker:builder_exec', "rm -rf #{release_backup_path}"
      invoke! :'docker:builder_exec', "mkdir -p #{release_backup_path}"
      invoke! :'docker:builder_exec', db_backup_cmd
      invoke! :'docker:builder_exec', images_backup_cmd
      invoke! :'docker:compose_up'

      on roles(:all) do
        within release_path do
          sudo "docker cp #{fetch(:builder_name)}:#{release_backup_path} #{fetch(:backups_path)}"
        end
      end
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
          directories_str = directories.map { |revision| "#{fetch(:backups_path)}/#{revision}" }.join(' ')

          within release_path do
            sudo "rm -rf #{directories_str}"
          end
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
      db_restore_cmd = "pg_restore --dbname=#{fetch(:dbname)} -O -j 20 -c #{release_backup_path.join('db')}"
      images_restore_cmd = "tar -xzf #{release_backup_path.join('uploads.tar.gz')} -C #{fetch(:project_home)}"

      invoke! :'docker:stop_container', 'nginx'
      invoke! :'docker:stop_container', 'sidekiq'
      invoke! :'docker:builder_exec', db_restore_cmd
      invoke! :'docker:builder_exec', "rm -rf #{fetch(:project_home)}/uploads/*"
      invoke! :'docker:builder_exec', images_restore_cmd
      invoke! :'docker:compose_up'
    end
  end

  desc 'Cleanup old images'
  task :cleanup_images do
    on roles(:all) do
      within release_path do
        sudo "docker rmi $(sudo docker images --filter 'dangling=true' -q --no-trunc)"
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

before :'deploy:started', :'docker:backup'
after :'deploy:published', :'docker:deploy'
after :'deploy:cleanup', :'docker:cleanup_backups'
after :'deploy:cleanup', :'docker:cleanup_images'
