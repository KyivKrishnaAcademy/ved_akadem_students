class ClassScheduleWithPeople < ClassSchedule
  REDIS_LOCK_KEY = 'class_schedule_with_people_mv_refresh'.freeze
  self.table_name = 'class_schedules_with_people'

  belongs_to :teacher, class_name: 'Person'

  def readonly?
    true
  end

  def destroy
    raise ActiveRecord::ReadOnlyRecord
  end

  def delete
    raise ActiveRecord::ReadOnlyRecord
  end

  def real_class_schedule
    ClassSchedule.find(id)
  end

  class << self
    def create
      raise ActiveRecord::ReadOnlyRecord
    end

    def refresh
      connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY #{table_name}")
    end

    def refresh_later
      Sidekiq.redis do |conn|
        # Redis.exists returns an integer (1 or 0), which is truthy in Ruby,
        # so convert to integer and check explicitly
        unless conn.exists(REDIS_LOCK_KEY).to_i.positive?
          conn.set(REDIS_LOCK_KEY, 1)
          RefreshClassSchedulesMvJob.set(wait: 5.minutes).perform_later
        end
      end
    end

    def teacher_schedule(person_id)
      where(teacher_id: person_id)
    end

    def student_schedule(person_id)
      where("'{?}'::int[] <@ people_ids", person_id)
    end

    def personal_schedule(person_id)
      teacher_schedule(person_id).or(student_schedule(person_id))
    end

    def next_day
      tomorrow = Time.zone.tomorrow
      beginning_of_day = tomorrow.beginning_of_day
      end_of_day = tomorrow.end_of_day

      where(start_time: beginning_of_day..end_of_day)
    end

    def personal_schedule_by_direction(person_id, page, direction)
      personal_schedule(person_id)
        .by_direction(direction)
        .page(page)
        .per(10)
    end
  end
end
