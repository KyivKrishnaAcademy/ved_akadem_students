class ClassScheduleWithPeople < ClassSchedule
  self.table_name = 'class_schedules_with_people'

  def readonly?
    true
  end

  def self.create
    raise ActiveRecord::ReadOnlyRecord
  end

  def destroy
    raise ActiveRecord::ReadOnlyRecord
  end

  def delete
    raise ActiveRecord::ReadOnlyRecord
  end

  def self.refresh
    connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY #{table_name}")
  end

  def self.refresh_later
    return if Sidekiq.redis { |c| c.exists(:class_schedule_with_people_mv_refresh) }

    Sidekiq.redis { |c| c.set(:class_schedule_with_people_mv_refresh, 1) }

    RefreshClassSchedulesMvJob.set(wait: 5.minutes).perform_later
  end

  def self.personal_schedule(person_id, page = nil)
    where('finish_time > now()')
      .where("teacher_id = ? OR '{?}'::int[] <@ people_ids", person_id, person_id)
      .order(:start_time, :finish_time)
      .page(page)
      .per(10)
  end

  def real_class_schedule
    ClassSchedule.find(id)
  end
end
