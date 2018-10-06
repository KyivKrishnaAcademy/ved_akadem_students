class SchedulesNotifierMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def next_day(person_id)
    schedules =
      ClassScheduleWithPeople
        .next_day
        .order(:start_time)
        .includes(:teacher, :classroom, :course, :academic_groups)

    @person = Person.find(person_id)
    @teacher_schedules = schedules.teacher_schedule(person_id)
    @student_schedules = schedules.student_schedule(person_id)
    @unsubscribe = Unsubscribe.generate(@person, 'notify_schedules')

    I18n.with_locale(@person.locale) do
      mail(to: @person.email)
    end
  end
end
