def rails_env
  ENV['RAILS_ENV'] || 'development'
end

environment rails_env

if rails_env == 'production'
  preload_app!

  threads 4, 4

  bind 'tcp://0.0.0.0:3000'

  project_home = ENV['PROJECT_HOME']

  pidfile "#{project_home}/tmp/puma.pid"
  state_path "#{project_home}/tmp/puma.state"
else
  bind 'tcp://localhost:3000'

  threads 0, 4
end

plugin :tmp_restart
