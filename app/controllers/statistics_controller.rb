class StatisticsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped

  def index
    @academic_group = policy_scope(AcademicGroup).find(params[:academic_group_id])

    authorize @academic_group

    schedules = @academic_group.class_schedules.where('start_time < ?', Time.zone.now).order(:start_time)
    schedule_dates = schedules.pluck(:start_time).map(&:to_date)

    @labels = schedule_dates.map { |d| d.strftime('%y.%m.%d') }
    @active_students = schedule_dates.map { |date| active_students_per_day(@academic_group.id, date) }
    @attended_students = schedules.map { |schedule| attendance_per_day(schedule) }
    @last_active_students = last_active_students(schedules)
  end

  private

  def active_students_per_day(academic_group_id, day)
    end_of_day = day.end_of_day

    GroupParticipation
      .where(academic_group_id: academic_group_id)
      .where('join_date < ?', end_of_day)
      .where('leave_date is NULL OR leave_date > ?', end_of_day)
      .count
  end

  def attendance_per_day(schedule)
    schedule.attendances.where(presence: true).count
  end

  def last_active_students(schedules)
    schedule_ids = schedules.last((schedules.count * 0.25).to_i).map(&:id)

    Attendance.where(class_schedule_id: schedule_ids).pluck(:student_profile_id).uniq.count
  end
end
