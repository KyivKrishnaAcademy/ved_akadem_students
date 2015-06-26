module ClassSchedulesLoadable
  extend ActiveSupport::Concern

  include ApplicationHelper
  include ClassSchedulesHelper
  include Rails.application.routes.url_helpers

  def as_json(opts = {})
    {
      class_schedules: @class_schedules.map { |cs| serialize_class_schedule cs },
      pages: @class_schedules.total_pages
    }
  end

  private

  def serialize_class_schedule(class_schedule)
    {
      id: class_schedule.id,
      subject: class_schedule.subject,
      course: serialize_course(class_schedule.course),
      lector: class_schedule.teacher_profile.present? ? serialize_lector(class_schedule.teacher_profile.person) : nil,
      academic_groups: class_schedule.academic_groups.map { |ag| serialize_academic_group ag },
      classroom: class_schedule.classroom.title,
      time: show_scheduled_time(class_schedule),
      can_edit: policy(class_schedule.real_class_schedule).edit?,
      can_delete: policy(class_schedule.real_class_schedule).destroy?,
      edit_path: edit_class_schedule_path(class_schedule),
      delete_path: class_schedule_path(class_schedule)
    }
  end

  def serialize_common(model)
    {
      id: model.id,
      title: model.title,
      can_view: policy(model).show?
    }
  end

  def serialize_course(course)
    serialize_common(course).merge(path: course_path(course))
  end

  def serialize_academic_group(group)
    serialize_common(group).merge(path: academic_group_path(group))
  end

  def serialize_lector(lector)
    {
      id: lector.id,
      path: person_path(lector),
      can_view: policy(lector).show?,
      complex_name: complex_name(lector, true)
    }
  end

  def policy(model)
    Pundit.policy(user, model)
  end
end
