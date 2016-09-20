def rails_env
  ENV['RAILS_ENV'] || 'development'
end

environment rails_env

if rails_env == 'production'
  daemonize true

  preload_app!

  threads 4, 4

  bind 'unix:///var/www/apps/ved_akadem_students/shared/tmp/puma/ved_akadem_students.sock'
  pidfile '/var/www/apps/ved_akadem_students/current/tmp/puma/pid'
  state_path '/var/www/apps/ved_akadem_students/current/tmp/puma/state'

  stdout_redirect(
    '/var/www/apps/ved_akadem_students/current/log/puma.stdout.log',
    '/var/www/apps/ved_akadem_students/current/log/puma.stderr.log',
    true
  )

  activate_control_app
else
  bind 'tcp://localhost:3000'

  threads 0, 4
end
