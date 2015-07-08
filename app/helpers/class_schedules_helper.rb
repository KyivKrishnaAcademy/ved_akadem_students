module ClassSchedulesHelper
  def class_schedule_title(class_schedule)
    @_class_schedule_title ||=
      "#{class_schedule.course.title}, #{l(class_schedule.start_time, format: :with_day)}, #{class_schedule.classroom.title}"
  end

  def time_value(time)
    time.present? ? l(time, format: :time_picker) : ''
  end

  def show_scheduled_time(class_schedule)
    "#{I18n.l(class_schedule.start_time, format: :with_day)} - #{I18n.l(class_schedule.finish_time, format: :just_time)}"
  end
end
