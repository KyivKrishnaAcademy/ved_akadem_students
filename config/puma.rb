rails_env = ENV['RAILS_ENV'] || 'development'

threads 4,4

bind  'unix:///var/www/apps/ved_akadem_students/socket/puma.sock'
pidfile '/var/www/apps/ved_akadem_students/current/tmp/puma/pid'
state_path '/var/www/apps/ved_akadem_students/current/tmp/puma/state'

activate_control_app
