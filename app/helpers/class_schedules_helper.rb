module ClassSchedulesHelper
  def class_schedule_title(class_schedule)
    @_class_schedule_title ||=
      "#{class_schedule.course.title}, #{l(class_schedule.start_time, format: :with_day)}, #{class_schedule.classroom.title}"
  end
end
