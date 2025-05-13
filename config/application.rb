require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VedicAcademyStudents
  class Application < Rails::Application
    config.autoload_paths = config.autoload_paths.dup
    config.eager_load_paths = config.eager_load_paths.dup
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Kyiv'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :uk
    config.i18n.enforce_available_locales = true

    config.generators do |g|
      g.test_framework(
        :rspec, fixtures: true, view_specs: true, helper_specs: true, controller_specs: true, routing_specs: false
      )
      g.factory_girl(true)
    end

    config.autoload_paths += %w[helpers interactions].map { |type| Rails.root.join('app', type, 'concerns') }
    config.eager_load_paths += [Rails.root.join('app/serializers')]
    config.assets.paths << Rails.root.join('node_modules')
    config.active_record.schema_format = :sql
    config.active_job.queue_adapter = :sidekiq
    config.responders.flash_keys = %i[success alert]

    # ActiveSupport.halt_callback_chains_on_return_false = false

    require 'yaml'

    Sidekiq.configure_server do |config|
      config.on(:startup) do
        sidekiq_config_path = File.expand_path('../config/sidekiq.yml', __dir__)
        sidekiq_config = YAML.safe_load(File.read(sidekiq_config_path), aliases: true, permitted_classes: [Symbol])

        schedule = sidekiq_config.dig('scheduler', 'schedule') || sidekiq_config.dig(:scheduler, :schedule)

        if schedule
          Sidekiq.schedule = schedule
          Sidekiq::Scheduler.reload_schedule!
        else
          Rails.logger.error 'Sidekiq Scheduler: schedule не найден в sidekiq.yml'
        end
      end
    end
  end
end
