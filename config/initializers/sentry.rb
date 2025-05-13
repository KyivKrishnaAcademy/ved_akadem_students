Sentry.init do |config|
  config.dsn = ENV.fetch('SENTRY_DSN', nil)

  config.enabled_environments = %w[staging production]

  config.send_default_pii = false
  config.before_send = lambda do |event, _hint|
    event.request&.data&.except!(*Rails.application.config.filter_parameters.map(&:to_s))
    event
  end
end
