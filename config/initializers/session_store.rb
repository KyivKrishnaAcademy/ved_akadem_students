# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :active_record_store, key: '_vedic_academy_students_session'

Rails.application.config.session_store :redis_session_store, {
  key: '_vedic_academy_students_session',
  serializer: :json,
  redis: {
    expire_after: 120.minutes,
    key_prefix: 'myapp:session:'
  }
}
