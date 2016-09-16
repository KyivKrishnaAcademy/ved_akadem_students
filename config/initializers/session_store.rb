Rails.application.config.session_store(
  :redis_session_store,
  key: '_vedic_academy_students_session',
  serializer: :json,
  redis: {
    expire_after: 1.week,
    key_prefix: 'myapp:session:'
  }
)
