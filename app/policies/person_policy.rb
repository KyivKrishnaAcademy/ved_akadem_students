class PersonPolicy < ApplicationPolicy
  def show_photo?
    owned? || show? || elder_of_student?(:curator_id) || elder_of_student?(:administrator_id) || classmate?
  end

  def show_passport?
    owned? || super
  end

  def crop_image?
    owned? || super
  end

  def update_image?
    crop_image?
  end

  def group_admins_index?
    academic_group_writable
  end

  def group_curators_index?
    academic_group_writable
  end

  def group_praepostors_index?
    academic_group_writable
  end

  private

  def academic_group_writable
    user.can_act?(%w(academic_group:edit academic_group:new))
  end

  def owned?
    record.id == user.id
  end

  def elder_of_student?(field)
    AcademicGroup.joins(student_profiles: [:person])
      .where(field => record.id, :student_profiles => { person_id: user.id })
      .any?
  end

  def classmate?
    user.last_academic_group.present? &&
      record.last_academic_group.present? &&
      user.last_academic_group.id == record.last_academic_group.id
  end
end
