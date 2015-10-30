class ClassSchedulePolicy < BasePolicy
  def ui_person?
    user.student_active? || user.teacher_profile.present?
  end
end
