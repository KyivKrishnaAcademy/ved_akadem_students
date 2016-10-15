redis_options = { url: 'redis://redis:6379/1', namespace: Rails.env }

Sidekiq.configure_server do |config|
  config.redis = redis_options
end

Sidekiq.configure_client do |config|
  config.redis = redis_options
end
