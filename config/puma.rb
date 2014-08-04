rails_env ||= ENV['RAILS_ENV'] || 'development'
port      ||= rails_env == 'production' ? 80 : 3000

preload_app!

threads 4,4

bind  'unix:///var/www/apps/ved_akadem_students/shared/tmp/puma/ved_akadem_students.sock'
pidfile '/var/www/apps/ved_akadem_students/current/tmp/puma/pid'
state_path '/var/www/apps/ved_akadem_students/current/tmp/puma/state'

activate_control_app
