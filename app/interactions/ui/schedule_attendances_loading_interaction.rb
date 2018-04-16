module Ui
  class ScheduleAttendancesLoadingInteraction < BaseInteraction
    include ClassSchedulesHelper

    def init
      @class_schedules = ClassSchedule
                           .joins(:academic_groups)
                           .includes(:attendances, :course)
                           .where(academic_groups: { id: params[:academic_group_id] })
                           .where('start_time <= now()')
                           .order(start_time: :desc, finish_time: :desc)
                           .page(params[:page])
                           .per(10)
    end

    def as_json(_opts = {})
      @as_json ||= {
        classSchedules: @class_schedules.map(&method(:serialize_class_schedule)).reverse
      }
    end

    private

    def serialize_class_schedule(class_schedule)
      {
        id: class_schedule.id,
        date: show_scheduled_time(class_schedule),
        attendances: class_schedule.attendances.map(&method(:serialize_attendance)).to_h,
        courseTitle: class_schedule.course.title
      }
    end

    def serialize_attendance(attendance)
      [
        attendance.student_profile_id,
        {
          id: attendance.id,
          revision: attendance.revision,
          presence: attendance.presence,
          scheduleId: attendance.class_schedule_id,
          studentProfileId: attendance.student_profile_id
        }
      ]
    end
  end
end
