class AcademicGroupPolicy < BasePolicy
  def show?
    super || student_of_the_group? || record.curator_id == user.id || record.administrator_id == user.id
  end

  def ui_index?
    user.can_act?(%w[class_schedule:edit class_schedule:new])
  end

  def group_list_pdf?
    super && show?
  end

  def attendance_template_pdf?
    super && show?
  end

  private

  def student_of_the_group?
    record.active_students.where(id: user.id).any?
  end
end
