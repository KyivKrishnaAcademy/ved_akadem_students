redis_options = { url: REDIS_URL, namespace: Rails.env }

Sidekiq.configure_server do |config|
  config.redis = redis_options
end

Sidekiq.configure_client do |config|
  config.redis = redis_options
end
