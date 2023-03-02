class PersonPolicy < BasePolicy
  def show_photo?
    owned? || show? || elder_of_student?(:curator_id) || elder_of_student?(:administrator_id) || classmate?
  end

  def crop_image?
    owned? || super
  end

  def update_image?
    crop_image?
  end

  def group_admins_index?
    user.can_act?(
      %w[
        academic_group:edit
        academic_group:new
        program:edit
        program:new
      ]
    )
  end

  def group_curators_index?
    academic_group_writable
  end

  def group_praepostors_index?
    academic_group_writable
  end

  def subscriptions_edit?
    owned? || super
  end

  def subscriptions_update?
    owned? || super
  end

  def journal?
    show?
  end

  private

  def academic_group_writable
    user.can_act?(%w[academic_group:edit academic_group:new])
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
    (actual_group_ids(user) & actual_group_ids(record)).any?
  end

  def actual_group_ids(person)
    return [] if person.student_profile.blank?

    person
      .student_profile
      .academic_groups
      .where('group_participations.leave_date IS NULL OR
              (academic_groups.graduated_at IS NULL AND group_participations.leave_date IS NULL) OR
              group_participations.leave_date >= academic_groups.graduated_at')
      .ids
  end
end
