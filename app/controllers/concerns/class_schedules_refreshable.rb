module ClassSchedulesRefreshable
  private

  def refresh_class_schedules_mv
    ClassScheduleWithPeople.refresh_later
  end
end
