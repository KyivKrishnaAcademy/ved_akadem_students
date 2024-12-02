Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN'] || Rails.application.secrets.sentry_dsn
  config.environments = %w[staging production development]
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
