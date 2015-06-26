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

  def self.personal_schedule(person, page = nil)
    ClassScheduleWithPeople.where('finish_time > now()')
                           .where("teacher_id = ? OR '{?}'::int[] <@ people_ids", person.id, person.id)
                           .page(page)
                           .per(10)
  end

  def real_class_schedule
    ClassSchedule.find(id)
  end
end
