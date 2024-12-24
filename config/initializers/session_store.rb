Rails.application.config.session_store(
  :redis_store,
  key: '_vedic_academy_students_session',
  serializer: :json,
  redis: {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
    expire_after: 1.week,
    key_prefix: 'myapp:session:'
  }
)