redis_url = ENV.fetch('REDIS_URL') { 'redis://127.0.0.1:6379/0/session' }

Rails.application.config.session_store :redis_store,
                                       servers: [redis_url],
                                       key: '_vedic_academy_students_session',
                                       expire_after: 1.week,
                                       secure: Rails.env.production?,
                                       threadsafe: true
