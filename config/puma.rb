def rails_env
  ENV['RAILS_ENV'] || 'development'
end

environment rails_env

if rails_env == 'production'
  preload_app!

  threads 4, 4

  bind 'tcp://0.0.0.0:3000'
  pidfile '/app/tmp/puma.pid'
  state_path '/app/tmp/puma.state'
else
  bind 'tcp://localhost:3000'

  threads 0, 4
end
