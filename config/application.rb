require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VedicAcademyStudents
  class Application < Rails::Application
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

    config.autoload_paths = config.autoload_paths.dup + %w[helpers interactions].map do |type|
                                                          Rails.root.join('app', type, 'concerns')
                                                        end
    config.active_record.schema_format = :sql
    config.active_job.queue_adapter = :sidekiq
    config.responders.flash_keys = %i[success alert]

    ActiveSupport.halt_callback_chains_on_return_false = false
  end
end
