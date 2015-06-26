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
    connection.execute("REFRESH MATERIALIZED VIEW #{table_name}")
  end

  def real_class_schedule
    ClassSchedule.find(id)
  end
end
