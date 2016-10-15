Rails.application.config.session_store(
  :redis_session_store,
  key: '_vedic_academy_students_session',
  serializer: :json,
  redis: {
    url: 'redis://redis:6379/1',
    expire_after: 1.week,
    key_prefix: 'myapp:session:'
  }
)
