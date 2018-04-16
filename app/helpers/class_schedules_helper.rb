module ClassSchedulesHelper
  def class_schedule_title(c_schedule)
    @class_schedule_title ||=
      "#{c_schedule.course.title}, #{l(c_schedule.start_time, format: :with_day)}, #{c_schedule.classroom.title}"
  end

  def time_value(time)
    time.present? ? l(time, format: :time_picker) : ''
  end

  def show_scheduled_time(c_schedule)
    "#{I18n.l(c_schedule.start_time, format: :with_day)} - #{I18n.l(c_schedule.finish_time, format: :just_time)}"
  end
end
